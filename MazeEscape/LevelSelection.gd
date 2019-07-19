extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var LEVELS_LOCATION = "res://Levels"
var level_button_resource = preload("res://LevelButton.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	#Trouver tous les niveaux, les ajouter sur la scène
	var list_levels = get_list_levels()
	var i = 1
	for level in list_levels:
		var level_button = level_button_resource.instance()
		level_button.level_number = i
		
		





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