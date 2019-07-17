extends Area2D

signal death
var enMarche = false
enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}
var d
var timer
var next_d = - 1
var next_position = Vector2(-1,-1)
var fly = 0
var death = false
func _ready():
	timer = 0
	d = DIRECTION.BAS

func _physics_process(delta):
	if(enMarche):	
		var movement = 50

		
		timer = timer + 1	
		if(timer % 30 == 0):
			match(d):
				DIRECTION.HAUT:
					position.y = position.y - 50
					global_rotation_degrees = 180
				DIRECTION.BAS:
					position.y = position.y + 50
					global_rotation_degrees = 0
				DIRECTION.GAUCHE:
					position.x = position.x - 50
					global_rotation_degrees = 90
				DIRECTION.DROITE:
					position.x = position.x + 50
					global_rotation_degrees = 270
			if(next_d != -1):
				d = next_d
				next_d = -1
			if(next_position != Vector2(-1,-1)):
				position = next_position
				next_position = Vector2(-1,-1)
			if fly > 0:
				fly -= 1 
			if(death):
				death=false
				emit_signal("death")