extends Control

signal arrow
signal jump
signal warp


func _on_Arrow_pressed():
	print("Arrow pressed")
	emit_signal("arrow")


func _on_Jump_pressed():
	print("Jump pressed")
	emit_signal("jump")

func _on_Teleporteur_pressed():
	print("Teleporteur pressed")
	emit_signal("warp")
	