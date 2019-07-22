extends AnimatedSprite

signal death
signal action
signal won

var enMarche = false
enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}
var d
var timer
var next_d = - 1
var next_position = Vector2(-1,-1)
var fly = 0
var last_fly = 0
var death = false
var won = false
func _ready():
	timer = 0
	init_rotation()

func _physics_process(delta):
	if(enMarche):	
	

		
		timer = timer + 1	
		if(timer % 30 == 0):
			if(won == true):
				emit_signal("won")
			if(death):
				d = -1
				next_d = -1
				emit_signal("death")	
				death=false			
			else:
				match(d):
					DIRECTION.HAUT:
						position.y = position.y - 400
						global_rotation_degrees = 270
					DIRECTION.BAS:
						position.y = position.y + 400
						global_rotation_degrees = 90
					DIRECTION.GAUCHE:
						position.x = position.x - 400
						global_rotation_degrees = 180
					DIRECTION.DROITE:
						position.x = position.x + 400
						global_rotation_degrees = 0
			if(next_d != -1):
				d = next_d
				next_d = -1
			if(next_position != Vector2(-1,-1)):
				position = next_position
				next_position = Vector2(-1,-1)
			if fly > 0:
				last_fly=fly
				fly -= 1 
			else:
				last_fly=0
			emit_signal("action")	
func init_rotation():
	match(d):
		DIRECTION.HAUT:
			global_rotation_degrees = 270
		DIRECTION.BAS:
			global_rotation_degrees = 90
		DIRECTION.GAUCHE:
			global_rotation_degrees = 180
		DIRECTION.DROITE:
			global_rotation_degrees = 0		
	
		