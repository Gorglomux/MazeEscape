extends Area2D
var enMarche = false
enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}
var d
var timer
var next_d = -1
var next_position = Vector2(-1,-1)
func _ready():
	timer = 0
	d = DIRECTION.BAS

func _physics_process(delta):
	if(enMarche):	

		timer = timer + 1	
		if(timer % 30 == 0):
			match(d):
				DIRECTION.HAUT:
					position.y = position.y - 50
				DIRECTION.BAS:
					position.y = position.y + 50
				DIRECTION.GAUCHE:
					position.x = position.x - 50
				DIRECTION.DROITE:
					position.x = position.x + 50
			if(next_d != -1):
				d = next_d
				next_d = -1
			if(next_position != Vector2(-1,-1)):
				position = next_position
				next_position = Vector2(-1,-1)
				