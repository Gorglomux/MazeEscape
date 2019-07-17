extends VBoxContainer

enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}

enum TILE_TYPE { GRAVAT, TROU, PLAYER, WALL, WARP,JUMP, ARROW, EXIT, ARROW_RIGHT,
 ARROW_LEFT, ARROW_UP, ARROW_DOWN}

var player_resource = preload("res://Player.tscn")

var OFFSET_X = 25
var OFFSET_Y = 25

var menu

var map

var player_actions

var current_action

var player

var warp_tiles = []
func load_map(board):
	self.map = board

	for cell in map.get_used_cells():
		match map.get_cellv(cell):
			TILE_TYPE.PLAYER:
				print(cell)
				player = player_resource.instance()
				
				player.position.x = map.map_to_world(cell).x+OFFSET_X
				player.position.y = map.map_to_world(cell).y+OFFSET_Y
				map.set_cellv(cell,-1)
				add_child(player)
			TILE_TYPE.WARP:
				warp_tiles.append(cell)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_collisions()
		
				

			

func check_collisions():
	var next_tile
	var next_position = map.world_to_map(player.position)
	match player.d:
		DIRECTION.GAUCHE : 
			next_tile = check_tile(next_position,1,0)
		DIRECTION.DROITE :
			next_tile = check_tile(next_position,-1,0)
		DIRECTION.HAUT : 
			next_tile = check_tile(next_position,0,1)
		DIRECTION.BAS: 
			next_tile = check_tile(next_position,0,-1)
	
	match map.get_cellv(next_tile): 
		TILE_TYPE.ARROW_LEFT:
			player.next_d = DIRECTION.GAUCHE
		TILE_TYPE.ARROW_RIGHT:
			player.next_d = DIRECTION.DROITE
		TILE_TYPE.ARROW_UP:
			player.next_d = DIRECTION.HAUT
		TILE_TYPE.ARROW_DOWN:
			player.next_d = DIRECTION.BAS
		TILE_TYPE.WALL:
			match player.d :
				DIRECTION.BAS :
					player.d = DIRECTION.DROITE
				DIRECTION.DROITE:
					player.d = DIRECTION.HAUT
				DIRECTION.HAUT:
					player.d = DIRECTION.GAUCHE
				DIRECTION.GAUCHE:
					player.d = DIRECTION.BAS	
		TILE_TYPE.WARP:
			#on utilise [] + car sinon le tableau est passé par référence
			var temp_warp = [] + warp_tiles
			for cell in temp_warp:
				print(cell)
			temp_warp.remove(temp_warp.find(next_tile))
			var warp_position = map.map_to_world(temp_warp[0])

			player.next_position = Vector2(warp_position.x + OFFSET_X, warp_position.y + OFFSET_Y)

func check_tile (initial_position, x,y):
	var normal = Vector2(x,y)
	var new_pos = initial_position - normal
	return new_pos


