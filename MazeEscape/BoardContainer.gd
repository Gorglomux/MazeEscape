extends MarginContainer

signal won 


enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}

enum TILE_TYPE { GRAVAT, TROU, PLAYER, WALL, WARP,EXIT, ARROW, JUMP , ARROW_RIGHT,
 ARROW_LEFT, ARROW_UP, ARROW_DOWN}

var player_resource = preload("res://Player.tscn")

var OFFSET_X = 25
var OFFSET_Y = 20

var menu

var map


var player_actions

var current_action

var player

var warp_tiles = []
#On charge la map et check si il y a un joueur pour l'instancier
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
		
				

			
#On teste les collisions selon les prochains déplacements du joueur 
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
	
	if	map.get_cellv(check_tile(next_position, 0,0)) == TILE_TYPE.EXIT:
			emit_signal("won")
	match map.get_cellv(next_tile): 
		TILE_TYPE.ARROW_LEFT:
			if(!player.fly > 0):
				player.next_d = DIRECTION.GAUCHE
		TILE_TYPE.ARROW_RIGHT:
			if(!player.fly > 0):
				player.next_d = DIRECTION.DROITE
		TILE_TYPE.ARROW_UP:
			if(!player.fly > 0):
				player.next_d = DIRECTION.HAUT
		TILE_TYPE.ARROW_DOWN:
			if(!player.fly > 0):
				player.next_d = DIRECTION.BAS
		TILE_TYPE.TROU:
			if(!player.fly > 0) : 
				player.death = true
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
			player.fly = 0
		TILE_TYPE.WARP:
			#on utilise [] + car sinon le tableau est passé par référence
			var temp_warp = [] + warp_tiles
			for cell in temp_warp:
				print(cell)
			temp_warp.remove(temp_warp.find(next_tile))
			var warp_position = map.map_to_world(temp_warp[0])
			player.next_position = Vector2(warp_position.x + OFFSET_X, warp_position.y + OFFSET_Y)
		TILE_TYPE.JUMP:
			player.fly = 2
			

func check_tile (initial_position, x,y):
	var normal = Vector2(x,y)
	var new_pos = initial_position - normal
	return new_pos

func reset():
	for i in get_children():
		i.queue_free()
