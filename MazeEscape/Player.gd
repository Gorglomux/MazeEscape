extends Area2D
var enMarche
enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}
var d
var timer

func _ready():
	enMarche = true
	timer = 0
	d = 3

func _physics_process(delta):
	if(enMarche):
		match(d):
			DIRECTION.HAUT:
				position.y = position.y - 2.5
			DIRECTION.BAS:
				position.y = position.y + 2.5
			DIRECTION.GAUCHE:
				position.x = position.x - 2.5
			DIRECTION.DROITE:
				position.x = position.x + 2.5
	
	timer = timer + 1
	
	if(timer % 20 == 0):
		d = (d + 1) % 4 
