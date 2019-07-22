extends MarginContainer

signal won 


enum DIRECTION{HAUT,BAS,GAUCHE,DROITE}

enum TILE_TYPE { GRAVAT, TROU, PLAYER, WALL, WARP,EXIT, ARROW, JUMP , ARROW_RIGHT,
 ARROW_LEFT, ARROW_UP, ARROW_DOWN}

var player_resource = preload("res://Player.tscn")

var OFFSET_X = 200
var OFFSET_Y = 200

var menu

var map


var player_actions

var current_action

var player
var playerArrow
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
				player.connect("action",self,"play_sound")
				map.set_cellv(cell,-1)
				add_child(player)
			TILE_TYPE.WARP:
				warp_tiles.append(cell)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_collisions()
		
				
func play_sound():
	var tile = check_tile(map.world_to_map(player.position),0,0)
	match map.get_cellv(tile):
		TILE_TYPE.EXIT:
			if(player.last_fly <=0):
				$Exit.play()
			else:
				$Move.play()
		TILE_TYPE.WARP:
			if(player.last_fly <=0):
				$Warp.play()			
			else:
				$Move.play()
		TILE_TYPE.JUMP:
			$Jump.play()
		TILE_TYPE.TROU:
			if(player.last_fly <= 0):
				$Fall.play()
			else:
				$Move.play()
		_:
			$Move.play()
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
	if	map.get_cellv(check_tile(next_position, 0,0)) == TILE_TYPE.EXIT && player.last_fly != 1:
			player.won = true
	if	map.get_cellv(check_tile(next_position, 0,0)) == TILE_TYPE.TROU && player.last_fly != 1:
			player.death = true
	if(!player.won &&!player.death && !next_tile == null):		
		match map.get_cellv(next_tile): 
			TILE_TYPE.ARROW_LEFT:
				if(player.fly <= 0):
					player.next_d = DIRECTION.GAUCHE
			TILE_TYPE.ARROW_RIGHT:
				if(player.fly <= 0):
					player.next_d = DIRECTION.DROITE
			TILE_TYPE.ARROW_UP:
				if(player.fly <= 0):
					player.next_d = DIRECTION.HAUT
			TILE_TYPE.ARROW_DOWN:
				if(player.fly <= 0):
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
				player.fly = 0
			TILE_TYPE.WARP:
				if(player.fly <= 0):
					#on utilise [] + car sinon le tableau est passé par référence
					var temp_warp = [] + warp_tiles
					if(temp_warp.size() > 1):
						temp_warp.remove(temp_warp.find(next_tile))
					var warp_position = map.map_to_world(temp_warp[0])
					player.next_position = Vector2(warp_position.x + OFFSET_X, warp_position.y + OFFSET_Y)
			TILE_TYPE.JUMP:
				player.fly = 2
			
func put_tile(pos, action):	

	var coords = Vector2(map.world_to_map(pos).x, map.world_to_map(Vector2(pos.x,pos.y-OFFSET_X)).y -1)
	#si il n'y a rien a l'emplacement du curseur
	if map.get_cellv(coords) == -1:
		if action == TILE_TYPE.WARP:
			warp_tiles.append(coords)
		map.set_cellv(coords,action)
		return true
	else :
		return false
	
func check_tile (initial_position, x,y):
	var normal = Vector2(x,y)
	var new_pos = initial_position - normal
	return new_pos

func reset():
	warp_tiles = []
	for i in get_children():
		if not i is  AudioStreamPlayer2D:
			i.queue_free()
