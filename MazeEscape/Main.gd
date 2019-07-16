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
func _ready():
	player_actions = $VBoxContainer/MarginContainer/PlayerActions
	menu = $VBoxContainer/MenuContainer/Menu 
	board = $VBoxContainer/BoardContainer
	board.load_map()
	player = board.player
	
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
	pass

func stop_game():
	player.enMarche  = false
	pass

func restart_game():
	get_tree().reload_current_scene()
	pass

func arrow_input():
	current_action = ACTION_TYPE.FLECHE

func jump_input():
	current_action = ACTION_TYPE.SAUT

func warp_input():
	current_action = ACTION_TYPE.WARP