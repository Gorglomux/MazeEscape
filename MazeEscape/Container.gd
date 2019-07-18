extends MarginContainer
signal container_clicked


func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("container_clicked",self,get_active_sprite())
	
func get_active_sprite():
	for i in get_children():
		if i is Sprite:
			if i.visible:
				return i



