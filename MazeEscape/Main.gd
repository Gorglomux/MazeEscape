extends Node2D

enum ACTION_TYPE { SAUT, FLECHE, WARP }

enum TILE_TYPE { GRAVAT, TROU, PLAYER, WALL, WARP,JUMP, ARROW, EXIT, ARROW_RIGHT,
 ARROW_LEFT, ARROW_UP, ARROW_DOWN}

var player_resource = preload("res://Player.tscn")

var menu

var map

var player_actions

var current_action

var player

var board
var board_container

var levelEnCours = 0

var LEVELS_LOCATION = "res://Levels"
func generation_niveau():
	var level
	# On récupère la liste de tous les niveaux et on initialise toutes les variable
	var list_levels = get_list_levels()
	var tile_size_x
	var tile_size_y
	
	# On charge un niveau aléatoirement
	level = load(LEVELS_LOCATION +"/"+ list_levels[levelEnCours]).instance()
	levelEnCours += 1
	board = level
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

func _ready():
	generation_niveau()
	
	player_actions = $VBoxContainer/MarginContainer/PlayerActions
	menu = $VBoxContainer/MenuContainer/Menu 
	board_container = $VBoxContainer/BoardContainer
	board_container.load_map(board)
	player = board_container.player
	
	menu.connect("play",self,"start_game")
	menu.connect("stop",self,"stop_game")
	menu.connect("restart",self,"restart_game")	
	
	player_actions.connect("arrow",self,"arrow_input")
	player_actions.connect("jump",self,"jump_input")
	player_actions.connect("warp",self,"warp_input")

		


func _process(delta):

	match current_action :
		ACTION_TYPE.SAUT:
			#change le curseur
			pass
		ACTION_TYPE.FLECHE:
			#change le curseur
			pass
		ACTION_TYPE.WARP:
			#change le curseur
			pass

func start_game():
	player.enMarche  = true

func stop_game():
	player.enMarche  = false

func restart_game():
	get_tree().reload_current_scene()

func arrow_input():
	current_action = ACTION_TYPE.FLECHE

func jump_input():
	current_action = ACTION_TYPE.SAUT

func warp_input():
	current_action = ACTION_TYPE.WARP