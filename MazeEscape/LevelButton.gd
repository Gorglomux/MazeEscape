extends MarginContainer

signal pressed

var level_number

func _ready():
	$Label.text=str(level_number)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("pressed",self)