extends VBoxContainer
class_name Card

enum Suits {STAR, PLANET}
var suit: int
var value: int
var picFront: Texture
var picBack: Texture = preload("res://icon.png")

var size: Vector2 = Vector2(100,100)

#Card Components
var tButton = TextureButton.new()

var valueHbox = HBoxContainer.new()
var valueLabel = Label.new()
var valueData = Label.new()

var suitHbox = HBoxContainer.new()
var suitLabel = Label.new()
var suitData = Label.new()

func _init(_suit, _value) -> void:
	value = _value
	suit = _suit
	picFront = get_picFront(_suit)
	
	tButton.expand = true
	tButton.set_custom_minimum_size(size)
	tButton.rect_size = size
	tButton.set_normal_texture(picFront)
	tButton.modulate = Color(rand_range(0.5, 1.0),rand_range(0.5, 1.0),rand_range(0.5, 1.0))
	add_child(tButton)
	
	valueLabel.text = "Value:"
	
	valueData.text = str(value)
	valueHbox.alignment = ALIGN_CENTER
	valueLabel.size_flags_horizontal = SIZE_EXPAND
	add_child(valueHbox)
	valueHbox.add_child(valueLabel)
	valueHbox.add_child(valueData)

	
	suitLabel.text = "Suit:"
	#done when getting pic suitData.text = str(value)
	suitLabel.size_flags_horizontal = SIZE_EXPAND
	add_child(suitHbox)
	suitHbox.alignment = ALIGN_CENTER
	suitHbox.add_child(suitLabel)
	suitHbox.add_child(suitData)
	
	

func _ready() -> void:
	set_h_size_flags(3)
	set_v_size_flags(3)
	

func get_picFront(_suit) -> Texture:
	var img : Texture
	if _suit == Suits.STAR:
		img = load("res://Textures/sunmap.jpg")
		suitData.text = "Star"
	elif _suit == Suits.PLANET:
		var images : Array = GameManager.list_files_in_directory("res://Textures/planetColors/", ".jpg")
		images.shuffle()
		img = load("res://Textures/planetColors/"+images[0])
		suitData.text = "Planet"
		#print(images)
	else: 
		img = picBack
	return img



