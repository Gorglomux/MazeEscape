extends Node2D

enum ACTION_TYPE { SAUT, FLECHE, WARP }

var menu

var map

var player_actions

var current_action

func _ready():
	player_actions = $VBoxContainer/MarginContainer/PlayerActions
	menu = $VBoxContainer/MenuContainer/Menu 
	map = $VBoxContainer/BoardContainer/Board
	
	menu.connect("play",self,"start_game")
	menu.connect("stop",self,"stop_game")
	menu.connect("restart",self,"restart_game")	
	
	player_actions.connect("arrow",self,"arrow_input")
	player_actions.connect("jump",self,"jump_input")
	player_actions.connect("warp",self,"warp_input")		

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	#player.enmarche  = true
	pass

func stop_game():
	#player.enmarche  = false
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