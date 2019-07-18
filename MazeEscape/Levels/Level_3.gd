extends TileMap


enum ACTION { ARROW_LEFT, ARROW_RIGHT, ARROW_UP, ARROW_DOWN, WARP, JUMP}
enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}
export(Array, ACTION) var actions 

export(DIRECTION) var starting_direction


func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
