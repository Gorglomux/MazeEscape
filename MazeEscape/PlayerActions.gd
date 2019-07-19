extends Control

signal input_sent
enum ACTIONS { ARROW_LEFT, ARROW_RIGHT, ARROW_UP, ARROW_DOWN, WARP, JUMP}

var container_resource = preload("res://Container.tscn")

var containers = []

func _ready():
	pass

func load_containers(types):
	var i = 0
	for type in types:
		var container = container_resource.instance()
		match type:
			ACTIONS.ARROW_LEFT:
				container.get_node("Arrow_left").show()
			ACTIONS.ARROW_RIGHT:
				container.get_node("Arrow_right").show()
			ACTIONS.ARROW_UP:
				container.get_node("Arrow_up").show()
			ACTIONS.ARROW_DOWN:
				container.get_node("Arrow_down").show()
			ACTIONS.WARP:
				container.get_node("Warp").show()
			ACTIONS.JUMP:
				container.get_node("Jump").show()
		container.rect_position.x = OS.window_size.x/4 - (types.size() * 60)/2 + 60 * i
		container.rect_position.y = 10
		i += 1
		container.connect("container_clicked",self,"on_container_clicked")
		add_child(container)
		containers.append(container)
func reset():
	for element in containers:
		element.queue_free()
	containers = []
func on_container_clicked(container, sprite):
	emit_signal("input_sent", container, sprite)