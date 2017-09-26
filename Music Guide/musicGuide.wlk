object joaquin {
	var grupo = "Pimpinela"
	var habilidad=20

method habilidad(){
	if (grupo!=null){
		return habilidad+20
	}
	return 20
}

method intepretaBien(cancion){
	return cancion.duracion()>300
}

method cuantoCobra(){
	if (grupo!=null){
		return 50
	}
	return 100
 }
}
	




object lucia {

var grupo = "Pimpinela"
var habilidad=70

method habilidad(){
	if(grupo!=null ){
		return habilidad-20 
	}
	return habilidad
}

method interpretaBien(cancion){
	return cancion.contains("familia")

}

method cuantoCobra(){
	if(lugar.esConcurrido()){
		return 5000
	}
	return 400
 }
}

object luisAlberto {
	
	var guitarra=fender
	
}

object fender {
	var valor=10
	method valor(){
		return valor
	}
}
object gibson {
	var v
}