extends Node2D


#physics
const GRAVITY = 0.4
var acceleration := Vector2(0,0)
var velocity : Vector2
var volume : float
var mass : float = 1
var density : float = 1
var size : int
var max_size: int = 512
var min_size: int = 100
var speed_scalor :=  0.000001

#game_data
var Suits := GameManager.Suits
var suit : int
export var star : bool = false

var dist_from_player : int
var player : Node2D

#layout
var vert_margin :int = 10
var vCont := VBoxContainer.new()

var nameBox := HBoxContainer.new()
var nameLabel := Label.new()
var nameValue := Label.new()

var distBox := HBoxContainer.new()
var distLabel := Label.new()
var distValue := Label.new()

var suitBox := HBoxContainer.new()
var suitLabel := Label.new()
var suitValue := Label.new()

var planet_name := "Uknown"

var secret : AudioStream

func _ready() -> void:

	declare_suit()
	setup_viewport_texture()
	size_and_layout()
	modulate_color()
	

#
func _physics_process(delta: float) -> void:
	process_all_planets()
	move_planets()
	update_dist_label()
	
	if $SecretPlayer2.is_playing():
		$PlanetSong.set_volume_db($PlanetSong.get_volume_db()-0.1)
		$PlanetSong2.set_volume_db($PlanetSong2.get_volume_db()-0.1)

	
#
func attract(cb :Node2D) -> Vector2:
	var force : Vector2 = cb.position - self.position
	var distance : float = force.length()
	distance = clamp(distance, 5, 25)
	
	force = force.normalized()
	var strength : float = (GRAVITY * mass * cb.mass) / distance * distance
	force *= strength #* 0.001
	return force
	
func apply_force(_force: Vector2) -> Vector2:
	var f = _force
	f /= mass
	acceleration += f
	return _force

func calc_dist(_toWhat:Vector2) -> float:
	var dist : float = self.position.distance_to(_toWhat)
	return dist

func calc_volume (_mass: float, _density:float) -> float:
	return _mass/_density
	
func check_orbit() -> void:
	#print("checking_orbit: " + planet_name )
	if suit == Suits.SECRET && planet_name == "Uknown":
		GameManager.secrets_discovered += 1
		planet_name = "SEC-00" + str(GameManager.secrets_discovered)
		nameValue.text = planet_name
		
		$SecretPlayer2.play()
		var vol1 := -80
		var vol2 := -6
#		while $SecretPlayer2.get_volume_db() < -18:
#			vol1 += 0.01
#			vol2 -= 0.01
#			$SecretPlayer2.set_volume_db(vol1)
#			$PlanetSong.set_volume_db(vol2)
#			$PlanetSong2.set_volume_db(vol2)
		
		$SecretPlayer2.play()
		yield(get_tree().create_timer(3), "timeout")
		$SecretPlayer.play()
	elif planet_name == "Uknown":
		#print("yupp, it's unknown")
		GameManager.alphabet.shuffle()
		planet_name = GameManager.alphabet[0] + GameManager.alphabet[1] + GameManager.alphabet[2] + "-" + str(int(rand_range(100,999)))
		nameValue.text = planet_name
	else:
		print(planet_name=="Uknown")
		#suitValue.text = "Secret Discovered"
	
func declare_suit()-> void:
	if star:
		suit = Suits.size()-1
		mass = 300
		density = 0.5
		velocity = Vector2(0,0)
		$PlanetSong.set_stream(GameManager.SongStar)
	else:
		velocity = Vector2(randf(),randf()) #* (randi()%5 + 1)
		setup_music()
#		mass = rand_range(0.5, 200)
#		density = rand_range(0.5, 5)
#		suit = randi() % (Suits.size()-2)
	suitValue.text = Suits.keys()[suit]

func modulate_color()-> void:
	var r:=rand_range(0.5,1.0)
	var g:=rand_range(0.5,1.0)
	var b:=rand_range(0.5,1.0)
	var c:=Color(r,g,b)
	self.modulate = c
func move_planets()->void:
	velocity +=acceleration*speed_scalor
	position += velocity
	acceleration *= 0

func process_all_planets() -> void:
	if not star:
		for c in get_parent().get_children():
			if c != self:
				var force : Vector2 = attract(c)
				var loc : Vector2 = c.position
				apply_force(force)
	
func size_and_layout() -> void:
	volume = calc_volume(mass,density) 
	size = int(GameManager.my_map(volume,0.1,400.0,min_size,max_size))
	#print(size)
	$Viewport.size = Vector2(size,size)
	
	var min_label_sizeX := 400
	$PlanetButton.rect_size = Vector2(size,size)
	$PlanetButton.rect_position = Vector2(-size/2, -size/2)
	
	vCont.set_custom_minimum_size(Vector2(min_label_sizeX,0))
	vCont.rect_position = Vector2(-min_label_sizeX/2, size/2)
	vCont.set_alignment(BoxContainer.ALIGN_CENTER)
	add_child(vCont)
	
	#name info
	nameBox.set_alignment(BoxContainer.ALIGN_CENTER)
	nameBox.set_custom_minimum_size(Vector2(min_label_sizeX,0))
	vCont.add_child(nameBox)
		
	nameLabel.text = "ID: "
	nameLabel.set_align(Label.ALIGN_RIGHT)
	nameLabel.set_custom_minimum_size(Vector2(min_label_sizeX/2,0))
	nameLabel.set_h_grow_direction(Control.GROW_DIRECTION_BEGIN)
	nameBox.add_child(nameLabel)

	nameValue.set_custom_minimum_size(Vector2(min_label_sizeX/2,0))
	nameValue.text = planet_name
	nameBox.add_child(nameValue)
	
	#dist info
	distBox.set_alignment(BoxContainer.ALIGN_CENTER)
	distBox.set_custom_minimum_size(Vector2(min_label_sizeX,0))
	vCont.add_child(distBox)
	
	
	distLabel.text = "Distance: "
	distLabel.set_align(Label.ALIGN_RIGHT)
	distLabel.set_custom_minimum_size(Vector2(min_label_sizeX/2,0))
	distLabel.set_h_grow_direction(Control.GROW_DIRECTION_BEGIN)
	distBox.add_child(distLabel)

	#distValue.text = "TEMP"
	distValue.set_custom_minimum_size(Vector2(min_label_sizeX/2,0))
	distBox.add_child(distValue)
#
#	#suit info
#	suitBox.set_alignment(BoxContainer.ALIGN_CENTER)
#	suitBox.set_custom_minimum_size(Vector2(min_label_sizeX,0))
#	vCont.add_child(suitBox)
#
#	suitLabel.text = "Suit: "
#	suitLabel.set_align(Label.ALIGN_RIGHT)
#	suitLabel.set_custom_minimum_size(Vector2(min_label_sizeX/2,0))
#	suitLabel.set_h_grow_direction(Control.GROW_DIRECTION_BEGIN)
#	suitBox.add_child(suitLabel)
#
#	#suitValue.text = "TEMP"
#	suitValue.set_custom_minimum_size(Vector2(min_label_sizeX/2,0))
#	suitBox.add_child(suitValue)

func setup_music()->void:
	var songs := GameManager.planet_songs
	if suit == Suits.SECRET:
		$PlanetSong.set_stream(GameManager.SongVoice)
		$PlanetSong2.set_stream(GameManager.SongVoice)
		$SecretPlayer.set_stream(secret)
		$PlanetSong.set_pitch_scale(0.5)
		$PlanetSong2.set_pitch_scale(0.25)
		$PlanetSong.set_max_distance(500)
		$PlanetSong2.play()
	elif suit == Suits.SUN:
		$PlanetSong.set_stream(GameManager.SongStar)
	else:
		var r0 := randi() % songs.size()
		$PlanetSong.set_stream(songs[r0])
		var r1 := randi() % 3
		match r1:
			0:$PlanetSong.set_pitch_scale(0.5)
			1:$PlanetSong.set_pitch_scale(1)
			2:$PlanetSong.set_pitch_scale(1.5)
	var vol :float = GameManager.my_map(size,min_size,max_size,-12.0,-3.0)
	if not $PlanetSong.get_stream() == GameManager.Song4:
		vol -= rand_range(-1,-3)
	$PlanetSong.set_volume_db(vol)
	$PlanetSong2.set_volume_db(vol)
	$PlanetSong.play()

func setup_viewport_texture() -> void:
	var vp : = $Viewport
	#vp.size = Vector2(size,size)
	#vp.transparent_bg = true
	#add_child(vp)
	
#	var cam := Camera.new()
#	cam.rotate_z(rand_range(0,TAU))
#	$Viewport.add_child(cam)
	
	var planet = PlanetMesh.new()
	planet.create_mesh(suit)
	planet.translation.z = -1.8
	$Viewport.add_child(planet)
	
	var vt : Texture = vp.get_texture()
	$PlanetButton.set_normal_texture(vt)


	

	


func _on_PlanetButton_pressed() -> void:
	GameManager.scene_root.player_target = self


func update_dist_label() -> void:
	dist_from_player = int(calc_dist(player.position))
	var s:= str(dist_from_player)
#	if dist_from_player< size:
#		s = "ORBITING"
		
	distValue.text = str(s)
	


func _on_PlanetButton_button_down():
	GameManager.scene_root.player_target = self
	#self.modulate = modulate - Color(0.1,0.1,0.1)
