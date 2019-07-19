extends Node2D


signal game_over
#Liste des types de tiles 
enum TILE_TYPE { GRAVAT, TROU, PLAYER, WALL, WARP,EXIT, ARROW, JUMP, ARROW_RIGHT,
 ARROW_LEFT, ARROW_UP, ARROW_DOWN}

#Liste des actions du joueur 
enum ACTION { ARROW_LEFT, ARROW_RIGHT, ARROW_UP, ARROW_DOWN, WARP, JUMP}

var object_links = {
	"Arrow_left": ACTION.ARROW_LEFT,
	"Arrow_right": ACTION.ARROW_RIGHT,
	"Arrow_up": ACTION.ARROW_UP,
	"Arrow_down": ACTION.ARROW_DOWN,
	"Warp": ACTION.WARP,
	"Jump": ACTION.JUMP
}

#Scène contenant le joueur
var player_resource = preload("res://Player.tscn")

var menu

var map

var player_actions

var current_action

var player

var board
var board_container

var x_dep
var y_dep

var levelEnCours = 0

var LEVELS_LOCATION = "res://Levels"

var cursor_sprite

var action_name
var last_container
func begin():
	player_actions = $VBoxContainer/HBoxContainer/ActionsContainer/PlayerActions
	menu = $VBoxContainer/HBoxContainer/MenuContainer/Menu
	board_container = $VBoxContainer/BoardContainer
	
	menu.connect("play",self,"start_game")
	menu.connect("stop",self,"stop_game")
	menu.connect("restart",self,"restart_game")	
	
	generation_niveau()
	player_actions.connect("input_sent",self,"process_inputs")

	board_container.connect("won", self, "on_win")
	player.connect("death",self,"stop_game")	



func _process(delta):
	if cursor_sprite != null:
		cursor_sprite.show()
		cursor_sprite.position.x = get_local_mouse_position().x
		cursor_sprite.position.y = get_local_mouse_position().y
		
func start_game():
	x_dep = player.position.x
	y_dep = player.position.y
	player.d = board.starting_direction
	player.enMarche  = true

func stop_game():
	player.position.x = x_dep
	player.position.y = y_dep
	player.d = board.starting_direction
	player.init_rotation()
	menu.reset()
	reset_cursor()
	player.enMarche  = false

func restart_game():
	levelEnCours -=1 
	menu.reset()
	reset_cursor()
	player_actions.reset()
	board_container.reset()
	generation_niveau()

func reset_cursor():
	if cursor_sprite !=null:
		cursor_sprite.queue_free()
		cursor_sprite = null
		action_name = null
	
func process_inputs(container, sprite):
	last_container = container
	action_name = object_links[sprite.get_name()]
	if cursor_sprite != null:
		cursor_sprite.queue_free()
	cursor_sprite = sprite.duplicate()
	cursor_sprite.set_texture(sprite.texture)
	add_child(cursor_sprite)

	
func on_win():
	menu.reset()
	player_actions.reset()
	board_container.reset()
	generation_niveau()
	player.d = board.starting_direction
	player.init_rotation()
	
func generation_niveau():

	var level
	# On récupère la liste de tous les niveaux et on initialise toutes les variable
	var list_levels = get_list_levels()
	if list_levels.size() - 1 < levelEnCours:
		emit_signal("game_over")
		return
	var tile_size_x
	var tile_size_y
	# On charge un niveau aléatoirement
	level = load(LEVELS_LOCATION +"/"+ list_levels[levelEnCours]).instance()
	player_actions.load_containers(level.actions)

	levelEnCours += 1
	$VBoxContainer/HBoxContainer/LevelContainer/Level.text = " Level - " + str(levelEnCours)
	board = level
	
	print(levelEnCours)
	board_container.load_map(board)
	player = board_container.player
	
	player.d = level.starting_direction
	player.init_rotation()
	
	$VBoxContainer/BoardContainer.add_child(level)
	

#Fonction servant a récupérer la liste de scènes (niveaux) contenue dans le fichier de niveaux
func get_list_levels():
	var files= []
	#On créé un nouveau Directory (pour parcourir l'arborescence de fichiers
	var dir = Directory.new()
	dir.open(LEVELS_LOCATION)
	#On commence la recherche dans l'arbre
	dir.list_dir_begin()
		
	#Tant que le nom de fichier n'est pas vide 
	while true:
		#On récupère le prochain fichier dans l'arborescence
		var file = dir.get_next()
		#Si le fichier est vide on arrête
		if file == "":
			break
		#Si le fichier n'est pas un fichier caché on l'ajoute
		elif !file.begins_with(".") && file.ends_with(".tscn") :
			files.append(file)
	dir.list_dir_end()
	return files


func _on_BoardContainer_gui_input(event):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT && event.pressed:
				var mouse_pos = get_local_mouse_position()
				
				if action_name != null : 
					var action
					match action_name:
						ACTION.ARROW_LEFT:
							action = TILE_TYPE.ARROW_LEFT
						ACTION.ARROW_RIGHT:
							action = TILE_TYPE.ARROW_RIGHT
						ACTION.ARROW_UP:
							action = TILE_TYPE.ARROW_UP
						ACTION.ARROW_DOWN:
							action = TILE_TYPE.ARROW_DOWN
						ACTION.WARP: 
							action = TILE_TYPE.WARP
						ACTION.JUMP:
							action = TILE_TYPE.JUMP
					var success = $VBoxContainer/BoardContainer.put_tile(mouse_pos, action)
					if success:
						last_container.hide()
						cursor_sprite.queue_free()
						cursor_sprite = null
						action_name = null
					