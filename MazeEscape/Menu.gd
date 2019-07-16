extends Node2D
signal play
signal stop
signal restart
var estCommencer

func _ready():
	estCommencer = false

func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
	estCommencer = false
	emit_signal("restart")
	print("J'ai restart le jeu")


func _on_PlayButton_pressed():
	if(estCommencer) :
		emit_signal("stop")
		estCommencer = false
		print("J'ai arrêter le jeu")
	else:
		emit_signal("play")
		estCommencer = true
		print("J'ai j'ai lancé le jeu")