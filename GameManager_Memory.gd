#https://www.youtube.com/watch?v=A60dT7RJfO8
extends Node

var scene_root : Node

var planet_deck : Array = []

var planet_grid: GridContainer

func _ready():
	randomize()
	fillDeck()
	dealDeck()
	
	
func fillDeck() -> void:
	for i in 5:
		planet_deck.append(Card.new(1, rand_range(1,100)))
	for i in planet_deck.size():
		var c = Card.new(1, planet_deck[i].value)
		c.tButton.set_normal_texture(planet_deck[i].picFront)
		c.tButton.modulate = planet_deck[i].tButton.modulate
		planet_deck.append(c)
	#planet_deck.append(Card.new(0,rand_range(1,100)))

	planet_deck.shuffle()
	
	
func dealDeck()-> void: 
	for i in planet_deck.size():
		planet_grid.add_child(planet_deck[i])

	
func list_files_in_directory(path: String, filetype: String):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && file.ends_with(filetype):
			files.append(file)

	dir.list_dir_end()

	return files
