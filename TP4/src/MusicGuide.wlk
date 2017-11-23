/*MUSICOS
/---------------------------------------------------------------------------*/
class Musico {
	var grupo
	var habilidad
	const albums = []
	var tipoDeEjecucion
	var tipoDeCobro
	
	constructor(_grupo, _habilidad, _tipoDeEjecucion, _tipoDeCobro){
		grupo = _grupo
		habilidad = _habilidad
		tipoDeEjecucion = _tipoDeEjecucion
		tipoDeCobro = _tipoDeCobro
	}
	
	method tipoDeEjecucion(tipo){
		tipoDeEjecucion = tipo
	}

	method tipoDeCobro(tipo){
		tipoDeCobro = tipo
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
	
	method canciones() = albums.flatMap{ album => album.canciones()}
	
	method cantidadDeCanciones() = self.canciones().size()
	
	method agregarAlbums( _albums) {
		albums.addAll(_albums)
	}
	
	method esAutorDe(cancion) = self.canciones().contains(cancion)
	
	method interpretaBien(cancion) = self.habilidad() > 60 || self.esAutorDe(cancion) 
		|| tipoDeEjecucion.interpretaBien(cancion)
		
	method esCompositor() = self.cantidadDeCanciones() >= 1
	
	method cobraPor(presentacion){
		return tipoDeCobro.cobraPor( self, presentacion )
	}
	
	method cualesInterpretaBien(canciones) = 
		canciones.filter{ cancion => self.interpretaBien(cancion)}
		
	method tocaSolo(presentacion) = presentacion.tocaSolo( self )
}

class MusicoDeGrupo inherits Musico{
	var bonusGrupo
	
	constructor(_grupo, _habilidad, _tipoDeEjecucion, _tipoDeCobro, _bonusGrupo) = 
	super(_grupo, _habilidad, _tipoDeEjecucion, _tipoDeCobro) {
		bonusGrupo = _bonusGrupo
	}
	
	override method habilidad(){
		if ( self.tocaEnGrupo() )
			return (habilidad + bonusGrupo)
		return habilidad			
	}	

}

class VocalistaPopular inherits Musico{

	override method habilidad (){
		if ( self.tocaEnGrupo() )
			return habilidad - 20
		return habilidad		
	}
		
}

object luisAlberto inherits Musico(null, 8, null, null) {
	var guitarra = fender
	
	method guitarra() = guitarra
	
	method usarGuitarra( unaGuitarra ){
		guitarra = unaGuitarra	
	}
	
	override method habilidad () = (guitarra.valor() * habilidad).min(100)
		
	override method interpretaBien(cancion) = true
	
	override method cobraPor ( presentacion ) {
		if ( presentacion.fecha() <= ( new Date(30,9,2017) ) )
			return 1000
		return 1200
	}

}

/*EJECUCION DE CANCIONES
/------------------------*/
class Palabrero {	
	var palabraClave
	
	constructor (_palabraClave){
		palabraClave = _palabraClave
	}	
	
	method interpretaBien(cancion) = cancion.letraTienePalabra(palabraClave) 
}

class Larguero {
	var duracionMinima
	
	constructor (_duracionMinima){
		duracionMinima = _duracionMinima
	}
	
	method interpretaBien(cancion) = cancion.duracion() > duracionMinima 
}

object imparero {
	method interpretaBien(cancion) = !cancion.duracion().even()
}

/*FORMAS DE COBRAR
/------------------------*/

class CobraSolitario {
	var cobroBase
	
	constructor (_cobroBase){
		cobroBase = _cobroBase
	}
		
	method cobraPor ( musico, presentacion ) {
		if ( musico.tocaSolo(presentacion) )
			return cobroBase
		return (cobroBase/2)
	}
}

class CobraPorCapacidad {
	var cobroBase
	var capacidadEsperada
	
	constructor (_cobroBase, _capacidadEsperada){
		cobroBase = _cobroBase
		capacidadEsperada = _capacidadEsperada
	}
		
	method cobraPor ( musico, presentacion ) {
		if ( presentacion.capacidadDelLugar() > capacidadEsperada )
			return cobroBase
		return ( cobroBase - 100 )		
	}
}

class CobraPorInflacion {
	var cobroBase
	var porcentajeInflacion
	var fechaLimite
	
	constructor (_cobroBase, _porcentajeInflacion, _fechaLimite){
		cobroBase = _cobroBase
		porcentajeInflacion = _porcentajeInflacion
		fechaLimite = _fechaLimite
	}
	
	method cobraPor ( musico, presentacion ) {
		if ( presentacion.fecha() < fechaLimite )
			return cobroBase
		return cobroBase + ( cobroBase * porcentajeInflacion / 100)		
	}
}

/*PRECENTACIONES
/---------------------------------------------------------------------------*/
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
	method fecha(_fecha){
		fecha = _fecha
	}
	
	method costo() = musicos.sum{musico => musico.cobraPor(self)}
	
	method tocaSolo ( unMusico ){
		return (musicos.contains(unMusico) && musicos.size() == 1)
	}
	
	method capacidadDelLugar() = lugar.capacidad(fecha)
	
	method esEnLugarConcurrido () = lugar.esConcurrido(fecha);
	
	method participaElMusico(musico) = musicos.contains(musico)
	
	method magia() = musicos.sum{ musico => musico.habilidad() }
}


object aliciaEnElPais inherits Cancion("Alicia en el Pais",510,"Quién sabe Alicia, este país no estuvo hecho porque sí. Te vas a ir, vas a salir pero te quedas, ¿dónde más vas a ir? Y es que aquí, sabes el trabalenguas, trabalenguas, el asesino te asesina, y es mucho para ti. Se acabó ese juego que te hacía feliz.")
{}

object pdpalooza inherits Presentacion ([], new Date(15,12,2017), lunaPark) {
	
	method agregarMusico( musico ){
		if ( self.checkearCriterio(musico) )
			musicos.add(musico)
	}
	
	method checkearCriterio(musico){
		if ( musico.habilidad() <= 70 )
			throw new UserException("La habilidad del musico es menor o igual a 70")
		if ( !musico.esCompositor() )
			throw new UserException("El musico no tiene canciones compuestas")
		if ( !musico.interpretaBien(aliciaEnElPais) )
			throw new UserException("El musico no interpreta bien la cancion 'Alicia en el Pais")
		return true
	}
}

class UserException inherits Exception { }

/*LUGARES
/---------------------------------------------------------------------------*/
class Lugar{
	var capacidad
	
	constructor(_capacidad){
		capacidad = _capacidad
	}
 
	method capacidad(_fecha) = capacidad 
	
	method esConcurrido(_fecha){
		return self.capacidad(_fecha) > 5000
	}	
}

object lunaPark inherits Lugar(9290){}

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
/---------------------------------------------------------------------------*/
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
/---------------------------------------------------------------------------*/
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
	method largo() = self.letra().words().size()
	method largoDelTitulo() = self.nombre().size()
	method esCorta() = self.duracion() < 180
	method letraTienePalabra(palabra) = self.letra().toLowerCase().words().contains(palabra.toLowerCase())
}

class Remix inherits Cancion{
	var cancionOriginal
	
	constructor(_nombre, _cancionOriginal) = super(_nombre, 0, "") {
		cancionOriginal = _cancionOriginal
	}
	
	override method letra() = "mueve tu cuerpo baby " + cancionOriginal.letra() + " yeah oh yeah"
	override method duracion() = cancionOriginal.duracion() * 3
}

class Mashup inherits Cancion{
	const canciones = []
	
	constructor(_nombre, _canciones) = super(_nombre, 0, "") {
		canciones = _canciones
	}
	
	override method letra() = canciones.fold("", {inicial, cancion => inicial + cancion.letra() + " "}).trim()
	override method duracion() = canciones.max{ cancion => cancion.duracion() }.duracion()
}


/*ALBUMS
/---------------------------------------------------------------------------*/
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
	method tieneBuenasVentas() = unidadesVendidas * 100 / unidadesSalieronALaVenta > 75
	method cancionMasLarga() = canciones.max{cancion => cancion.largo()}
	method cancionMasLarga(criterio) {
		return canciones.max(criterio)
	}
}

/*Criterios de comparacion
/---------------------------------------------------------------------------*/

object criterioDuracion{
	method apply(cancion) = cancion.duracion()
}

object criterioLargoLetra{	
	method apply(cancion) = cancion.largo()
}

object criterioLargoTitulo{	
	method apply(cancion) = cancion.largoDelTitulo()
}

/*BANDAS
/---------------------------------------------------------------------------*/
class Banda{
	const musicos = []
	const discos = []
	var representante
	
	constructor (_musicos, _discos, _representante){
		musicos = _musicos
		discos = _discos
		representante = _representante	
	}
	
	method habilidad() = musicos.sum{ musico => musico.habilidad() } * 1.1
	
	method cobraPor(presentacion) = 
		musicos.sum{ 
			musico => musico.cobraPor(presentacion)
		} + representante.cobra()
		
	method interpretaBien(cancion) = musicos.all{ musico => musico.interpretaBien(cancion) }
}


/*Representante
/*---------------------------------------------------------------------------*/
class Representante{
	var pesos
	
	constructor(_pesos){
		pesos = _pesos
	}
	
	method cobra() = pesos
}
