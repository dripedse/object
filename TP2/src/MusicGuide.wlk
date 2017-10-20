/*MUSICOS
/**************************************************************************/
class Musico {
	var grupo
	var habilidad
	var albums =[]
	
	constructor(_grupo, _habilidad, _albums){
		grupo = _grupo
		habilidad = _habilidad
		albums = _albums
	}
			
	method grupo() = grupo
	method grupo(_grupo) {
		grupo = _grupo
	}
	
	method habilidad() = habilidad
	method habilidad(_habilidad){
		habilidad = _habilidad
	}
	
	method dejarGrupo(){
		grupo = null
	}
	
	method tocaEnGrupo() = (grupo != null)
	
	method esMinimalista() = albums.all{ album => album.esMinimalista()}
	
	method cancionesConPalabra (palabra){
		return self.canciones().filter{ cancion => cancion.letraTienePalabra(palabra)}
	}
	
	method duracionObra() = albums.sum{ album => album.duracion() }
	
	method laPego() = albums.all{ album => album.tieneBuenasVentas()}
	
	method canciones() {
		const canciones = []
		albums.forEach{ album => canciones.addAll(album.canciones()) }
		return canciones
	}
}

class MusicoDeGrupo inherits Musico{
	var bonusGrupo
	
	constructor(_grupo, _habilidad, _albums, _bonusGrupo) = super(_grupo, _habilidad, _albums) {
		bonusGrupo = _bonusGrupo
	}
	
	override method habilidad(){
		if ( grupo != null )
			return (habilidad + bonusGrupo)
		else
			return habilidad			
	}	
	
	method interpretaBien ( cancion ) = cancion.duracion() > 300
	
	method cobraPor ( presentacion ) {
		if ( self.tocaSolo(presentacion) )
			return 100
		else 
			return 50//toca solo	
	}
	
	method tocaSolo(presentacion) {
		return presentacion.tocaSolo(self)
	}	
}

class VocalistaPopular inherits Musico{
	var palabraClave
	
	constructor(_grupo, _habilidad, _albums, _palabraClave) = super(_grupo, _habilidad, _albums) {
		palabraClave = _palabraClave
	}
		
	override method habilidad (){
		if ( grupo != null )
			return habilidad - 20
		else
			return habilidad		
	}
	
	method interpretaBien ( cancion ) = cancion.letraTienePalabra(palabraClave)
		
	method cobraPor ( presentacion ) {
		if ( presentacion.esEnLugarConcurrido() )
			return 500
		return 400
	}		
}

object luisAlberto inherits Musico(null, 8, [paraLosArboles, justCrisantemo]) {
	var guitarra = fender
	
	method guitarra() = guitarra
	
	method usarGuitarra( unaGuitarra ){
		guitarra = unaGuitarra	
	}
	
	override method habilidad () = (guitarra.valor() * habilidad).min(100)
		
	method interpretaBien ( cancion ) = true
	
	method cobraPor ( presentacion ) {
		if ( presentacion.fecha() <= ( new Date(30,9,2017) ) )
			return 1000
		return 1200
	}
}

object joaquin inherits MusicoDeGrupo("Pimpinela", 20, [especialLaFamilia], 5){}
object lucia inherits VocalistaPopular("Pimpinela", 70, [], "familia"){}
object kike inherits MusicoDeGrupo(null, 60, [], 20){}
object soledad inherits VocalistaPopular(null, 55, [laSole], "amor"){}

/*PRECENTACIONES
/**************************************************************************/
class Presentacion {
	var musicos
	var fecha
	var lugar
	
	constructor (_musicos, _fecha, _lugar){
		musicos = _musicos
		fecha = _fecha
		lugar = _lugar	
	}
	
	method musicos() = musicos
	method musicos(_musicos){
		musicos = _musicos
	}
	method lugar() = lugar		
	method fecha() = fecha
	
	method costo() = musicos.sum{musico => musico.cobraPor(self)}
	
	method tocaSolo ( unMusico ){
		return (musicos.contains(unMusico) && musicos.size() == 1)
	}
	
	method esEnLugarConcurrido () = lugar.esConcurrido(fecha);
}

object presentacionLuna inherits Presentacion([luisAlberto, joaquin, lucia], 
	new Date(20,04,2017), lunaPark
)
{}

object presentacionTrastienda inherits Presentacion([luisAlberto, joaquin, lucia],
	new Date(15,11,2017), laTrastienda
)
{}

/*LUGARES
/**************************************************************************/
object lunaPark{
	var capacidad = 9290
	
	method capacidad(_fecha) = capacidad 
	//pido fecha para poder usar esEnLugarConcurrido() de Presentaciones
	
	method esConcurrido(_fecha){
		return self.capacidad(_fecha) > 5000
	}		
}

object laTrastienda{
	var capacidadPlantaBaja = 400
	var capacidadPrimerPiso = 300
	
	method capacidad( _fecha ){
		if ( _fecha.dayOfWeek() == 6)
			return capacidadPlantaBaja + capacidadPrimerPiso
		return
			capacidadPlantaBaja
	}
	
	method esConcurrido(_fecha){
		return self.capacidad(_fecha) > 5000
	}		
}

/*GUITARRAS
/**************************************************************************/
object fender{
	var ug = 10

	method valor()= ug	
}

object gibson{
	var ug = 15
	var estaSana = true
		
	method estaSana() = estaSana
	method estaSana( _estaSana ){
		estaSana = _estaSana
	}	
		
	method valor(){
		if ( estaSana )
			return ug
		else
			return 5
	}
	
	method romper(){
		estaSana = false
	}
	
	method arreglar(){
		estaSana = true
	}
}
/*CANCIONES
/**************************************************************************/
class Cancion{
	var nombre
	var duracion
	var letra
	
	constructor (_nombre, _duracion, _letra){
		nombre = _nombre
		duracion = _duracion
		letra = _letra	
	}
	
	method nombre() = nombre
	method duracion() = duracion
	method letra() = letra
	method largo() = letra.size()
	method esCorta() = duracion < 180
	method letraTienePalabra(palabra) = letra.toLowerCase().contains(palabra.toLowerCase())
}

object cisne inherits Cancion("Cisne", 312, "Hoy el viento se
abrió quedó vacío el aire una vez más y el manantial brotó y nadie está
aquí​ ​y​ ​puedo​ ​ver​ ​que​ ​solo​ ​estallan​ ​las​ ​hojas​ ​al​ ​brillar"){}

object laFamilia inherits Cancion("La Familia", 264, "Quiero brindar
por​ ​mi​ ​gente​ ​sencilla,​ ​por​ ​el​ ​amor​ ​brindo​ ​por​ ​la​ ​familia"){}

object eres inherits Cancion("Eres", 145, "Eres lo mejor que me pasó en la vida, 
no tengo duda, no habrá más nada después de ti. Eres lo que le dio brillo al día 
a día, y así será por siempre, no cambiará, hasta el final de mis días."){}

object corazonAmericano inherits Cancion("Corazon Americano", 154, "Canta corazón, 
canta más alto, que tu pena al fin se va marchando, el nuevo milenio ha de encontrarnos, 
junto corazón, como soñamos."){}

object almaDeDiamante inherits Cancion("Alma de diamante", 216, "Ven a mí con tu dulce luz 
alma de diamante. Y aunque el sol se nuble después sos alma de diamante. Cielo o piel silencio 
o verdad sos alma de diamante. Por eso ven así con la humanidad alma de diamante"){}

object crisantemo inherits Cancion("Crisantemo", 175, "Tócame junto a esta pared, yo quede 
por aquí... cuando no hubo más luz... quiero mirar a través de mi piel... Crisantemo, que se 
abrió... encuentra el camino hacia el cielo"){}

/*ALBUMS
/**************************************************************************/
class Album{
	var titulo
	const canciones = []
	var fecha
	var unidadesSalieronALaVenta
	var unidadesVendidas
	
	constructor(_titulo, _canciones, _fecha, _unidadesSalieronALaVenta, _unidadesVendidas){
		titulo = _titulo
		canciones = _canciones
		fecha = _fecha
		unidadesSalieronALaVenta = _unidadesSalieronALaVenta
		unidadesVendidas = _unidadesVendidas
	}
	
	method titulo()= titulo
	method canciones() = canciones
	method fecha() = fecha
	method unidadesSalieronALaVenta() = unidadesSalieronALaVenta
	method unidadesVendidas() = unidadesVendidas
	
	method duracion() = canciones.sum{ cancion => cancion.duracion() }
	method esMinimalista() = canciones.all{cancion => cancion.esCorta()}
	method cancionMasLarga() = canciones.max{cancion => cancion.largo()}
	method tieneBuenasVentas() {
		if ( unidadesVendidas * 100 / unidadesSalieronALaVenta > 75)
			return true
		return false
	}
}

object especialLaFamilia inherits Album("Especial La Familia", [laFamilia], new Date (17,06,1992), 100000, 89000){}
object laSole inherits Album("La Sole", [eres, corazonAmericano], new Date (4,2,2005), 200000, 130000){}
object paraLosArboles inherits Album("Para Los Arboles", [cisne, almaDeDiamante], new Date (31,3,2003), 50000, 49000){}
object justCrisantemo inherits Album("Just Crisantemo", [crisantemo], new Date (05,12,2007), 28000, 27500){}
