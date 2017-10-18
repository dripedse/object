/*MUSICOS
/**************************************************************************/
object joaquin{
	var grupo = "Pimpinela"
	var habilidad = 20
	
	method grupo() = grupo
	method grupo(_grupo) {
		grupo = _grupo
	}
	
	method habilidad(){
		if ( grupo != null )
			return habilidad + 5
		else
			return habilidad			
	}
	method habilidad(_habilidad){
		habilidad = _habilidad
	}	
	
	method interpretaBien ( cancion ) = cancion.duracion() > 300
	
	method cobraPor ( presentacion ) {
		if ( self.tocaSolo(presentacion) )
			return 100
		else 
			return 50
	}
	
	method tocaSolo(presentacion) {
		return presentacion.tocaSolo(self) 
	}	
	
	method dejarGrupo(){
		grupo = null
	}	
}

object lucia{
	var grupo = "Pimpinela"
	var habilidad = 70
	
	method grupo() = grupo
	method grupo(_grupo) {
		grupo = _grupo
	}
	
	method habilidad(){
		if ( grupo != null )
			return habilidad - 20
		else
			return habilidad		
	}
	method habilidad(_habilidad){
		habilidad = _habilidad
	}		

	method interpretaBien ( cancion ) = cancion.letraTienePalabra("familia")
	
	method cobraPor ( presentacion ) {
		if ( presentacion.esEnLugarConcurrido() )
			return 500
		else
			return 400
	}
	
	method dejarGrupo(){
		grupo = null
	}		
}

object luisAlberto{
	var grupo = null
	var habilidad = 8
	var guitarra = fender
	
	method grupo() = grupo
	method grupo(_grupo) {
		grupo = _grupo
	}	
	
	method guitarra() = guitarra
	
	method usarGuitarra( unaGuitarra ){
		guitarra = unaGuitarra	
	}
	
	method habilidad () = (guitarra.valor() * habilidad).min(100)
	method habilidad(_habilidad){
		habilidad = _habilidad
	}	
		
	method interpretaBien ( cancion ) = true
	
	method cobraPor ( presentacion ) {
		if ( presentacion.fecha() <= ( new Date(30,9,2017) ) )
			return 1000
		return 1200
	}
	
	method dejarGrupo(){
		grupo = null
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
	
	method letraTienePalabra(palabra) = self.letra().toLowerCase().contains(palabra.toLowerCase())
}
/*
object cisne inherits Cancion("Cisne", 312, "Hoy el viento se
abrió quedó vacío el aire una vez más y el manantial brotó y nadie está
aquí​ ​y​ ​puedo​ ​ver​ ​que​ ​solo​ ​estallan​ ​las​ ​hojas​ ​al​ ​brillar"){}

object laFamilia inherits Cancion("La Familia", 264, "Quiero brindar
por​ ​mi​ ​gente​ ​sencilla,​ ​por​ ​el​ ​amor​ ​brindo​ ​por​ ​la​ ​familia"){}
*/

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
	
	method tocaSolo ( unMusico ){
		return (self.musicos().contains(unMusico) && self.musicos().size() == 1)
	}
	
	method esEnLugarConcurrido () = self.lugar().esConcurrido(self.fecha());
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
}
