/*MUSICOS
/**************************************************************************/
class Musico {
	var grupo
	var habilidad
	
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
	
	method interpretaBien ( cancion ) = true
	method cobraPor ( presentacion ) = 100
	method dejarGrupo(){
		grupo = null
	}
}

object joaquin inherits Musico("Pimpinela", 20){	
	override method habilidad(){
		if ( grupo != null )
			return habilidad + 5
		else
			return habilidad			
	}
	
	override method interpretaBien ( cancion ) = cancion.duracion() > 300
	
	override method cobraPor ( presentacion ) {
		if ( self.tocaSolo(presentacion) )
			return 50
		else 
			return 100//toca solo	
		// y si no esta en la presentacion???
	}
	
	method tocaSolo(presentacion) {
		return presentacion.musicos().contains(self) && presentacion.musicos().size() > 1 
	}
}

object lucia inherits Musico("Pimpinela", 70){
	override method habilidad (){
		if ( grupo != null )
			return habilidad - 20
		else
			return habilidad		
	}
		
	override method interpretaBien ( cancion ) = cancion.nombre().toLowerCase().contains("familia")
	
	override method cobraPor ( presentacion ) {
		if ( presentacion.lugar().esConcurrido(presentacion.fecha()) )
			return 500
		else
			return 400
	}
}

object luisAlberto inherits Musico(null, 8) {
	const guitarras = [fender, gibson]
	var guitarra = fender
	
	method guitarra() = guitarra
	
	method usarGuitarra( unaGuitarra ){
		if (guitarras.contains(unaGuitarra))
			guitarra = unaGuitarra	
	}
	
	override method habilidad (){
		var habilidadTotal = guitarra.valor() * habilidad	
		if ( habilidadTotal >= 100)
			return 100
		else 
			return habilidadTotal
	}
		
	override method interpretaBien ( cancion ) = true
	
	override method cobraPor ( presentacion ) {
		if ( (presentacion.fecha().year() == 2017 && presentacion.fecha().month() <= 9) || 
		presentacion.fecha().year() < 2017){
			return 1000
		}
		else
			return 1200
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
}

object cisne inherits Cancion("Cisne", 312, "Hoy el viento se
abrió quedó vacío el aire una vez más y el manantial brotó y nadie está
aquí​ ​y​ ​puedo​ ​ver​ ​que​ ​solo​ ​estallan​ ​las​ ​hojas​ ​al​ ​brillar"){}

object laFamilia inherits Cancion("La Familia", 264, "Quiero brindar
por​ ​mi​ ​gente​ ​sencilla,​ ​por​ ​el​ ​amor​ ​brindo​ ​por​ ​la​ ​familia"){}

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
	
	method costo(){
		return musicos.sum{musico => musico.cobraPor(self)}
	}
}

object presentacionLuna inherits Presentacion([luisAlberto, joaquin, lucia], 
	new Date(20,04,2017), lunaPark
){
}

object presentacionTrastienda inherits Presentacion([luisAlberto, joaquin, lucia],
	new Date(15,11,2017), laTrastienda
)
{}

/*LUGARES
/**************************************************************************/
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
object lunaPark inherits Lugar(9290)
{}

object laTrastienda inherits Lugar(0){
	var capacidadPlantaBaja = 400
	var capacidadPrimerPiso = 300
	
	override method capacidad( _fecha ){
		if ( _fecha.dayOfWeek() == 6)
			return capacidadPlantaBaja + capacidadPrimerPiso
		return
			capacidadPlantaBaja
	}
}

/*GUITARRAS
/**************************************************************************/
class Guitarra{
	var ug
	var estaSana
	
	constructor(_ug, _estaSana){
		ug = _ug
		estaSana = _estaSana
	}
	
	method valor()= ug
	method estaSana() = estaSana
	method estaSana( _estaSana ){
		estaSana = _estaSana
	}	
}

object fender inherits Guitarra(10, true){
}

object gibson inherits Guitarra(15, true) {
	override method valor(){
		if ( estaSana )
			return ug
		else
			return 5
	}
}
