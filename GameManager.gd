#https://www.youtube.com/watch?v=A60dT7RJfO8
extends Node

var scene_root : Node

var test_texture :Texture= preload("res://Textures/planetColors/plutomap1k.jpg")
var planet_texture_folder : String = "res://Textures/planetColors/"
var planet_texture_paths : Array = []
var planet_textures : Array = [test_texture]


var SongStar : AudioStream = preload("res://Export_SevenSecrets/3mAggressiveDrone.WAV")
var Song0 : AudioStream = preload("res://Export_SevenSecrets/1mDroneFaded.WAV")
var Song1 : AudioStream = preload("res://Export_SevenSecrets/1mMelodicDroneFaded.WAV")
var Song2 : AudioStream = preload("res://Export_SevenSecrets/3mDroneFaded.WAV")
var Song3 : AudioStream = preload("res://Export_SevenSecrets/3mDroneMelodicFadedLong.WAV")
var Song4 : AudioStream = preload("res://Export_SevenSecrets/3mMelodicVoice.WAV")

var SongEcho : AudioStream = preload("res://Export_SevenSecrets/45sPulseEcho_01.WAV")
var SongVoice : AudioStream = preload("res://Export_SevenSecrets/30sVoiceClean.WAV")


var Secret0: AudioStream = preload("res://Export_SevenSecrets/Secret0_1.wav")
var Secret1: AudioStream = preload("res://Export_SevenSecrets/Secret1_1.wav")
var Secret2: AudioStream = preload("res://Export_SevenSecrets/Secret2_1.wav")
var Secret3: AudioStream = preload("res://Export_SevenSecrets/Secret3_1.wav")
var Secret4: AudioStream = preload("res://Export_SevenSecrets/secret4_1.wav")
var Secret5: AudioStream = preload("res://Export_SevenSecrets/secret5_1.wav")
var Secret6: AudioStream = preload("res://Export_SevenSecrets/Secret6_1.wav")
var secrets := [Secret0,Secret1,Secret2,Secret3,Secret4,Secret5,Secret6]

var planet_songs : Array = [Song0,Song1,Song2,Song3,Song4,Song4,Song4,Song4]

var secrets_discovered : int = 0

var alphabet := ["A","B","C","D","E","F",'G','H','I',"J","K","L",'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']

enum Suits {
	TECHNICAL,
	EMPATHY,
	INTELLIGENCE,
	FOCUS,
	SECRET,
	SUN
}

#var planet_deck : Array = []

#var planet_grid: GridContainer
func _init() ->void:
	planet_texture_paths = list_files_in_directory(planet_texture_folder, ".jpg")
	for i in planet_texture_paths:
		var img: Texture = load(planet_texture_folder+i)
		planet_textures.append(img)


func _ready():
	randomize()
	secrets.shuffle()
	
	#fillDeck()
	#dealDeck()
	
	
#func fillDeck() -> void:
#	for i in 5:
#		planet_deck.append(Card.new(1, rand_range(1,100)))
#	for i in planet_deck.size():
#		var c = Card.new(1, planet_deck[i].value)
#		c.tButton.set_normal_texture(planet_deck[i].picFront)
#		c.tButton.modulate = planet_deck[i].tButton.modulate
#		planet_deck.append(c)
#	#planet_deck.append(Card.new(0,rand_range(1,100)))
#
#	planet_deck.shuffle()
#
#
#func dealDeck()-> void: 
#	for i in planet_deck.size():
#		planet_grid.add_child(planet_deck[i])
#
#
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

func my_map (value: float, istart: float, istop: float, ostart:float, ostop:float) -> float:
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))
