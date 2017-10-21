/*MUSICOS
/**************************************************************************/
class Musico {
	var grupo
	var habilidad
	var albums =[]
	
	constructor(_grupo, _habilidad){
		grupo = _grupo
		habilidad = _habilidad
	}
			
	method grupo() = grupo
	method grupo(_grupo) {
		grupo = _grupo
	}
	
	method habilidad() = habilidad
	method habilidad(_habilidad){
		habilidad = _habilidad
	}
	
	method albums() = albums
	
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
	
	method canciones() = albums.map{ album => album.canciones()}.flatten()
	
	method agregarAlbums( _albums) {
		albums.addAll(_albums)
	}
}

class MusicoDeGrupo inherits Musico{
	var bonusGrupo
	
	constructor(_grupo, _habilidad, _bonusGrupo) = super(_grupo, _habilidad) {
		bonusGrupo = _bonusGrupo
	}
	
	override method habilidad(){
		if ( self.tocaEnGrupo() )
			return (habilidad + bonusGrupo)
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
	
	constructor(_grupo, _habilidad, _palabraClave) = super(_grupo, _habilidad) {
		palabraClave = _palabraClave
	}
		
	override method habilidad (){
		if ( self.tocaEnGrupo() )
			return habilidad - 20
		return habilidad		
	}
	
	method interpretaBien ( cancion ) = cancion.letraTienePalabra(palabraClave)
		
	method cobraPor ( presentacion ) {
		if ( presentacion.esEnLugarConcurrido() )
			return 500
		return 400
	}		
}

object luisAlberto inherits Musico(null, 8) {
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
	method largo() = letra.split(' ').size()
	method esCorta() = duracion < 180
	method letraTienePalabra(palabra) = letra.toLowerCase().contains(palabra.toLowerCase())
}

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
	method tieneBuenasVentas() = unidadesVendidas * 100 / unidadesSalieronALaVenta > 75
}
