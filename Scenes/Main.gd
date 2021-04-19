extends Node2D


var planet_card : PackedScene = preload("res://Scenes/PlanetCard.tscn")

var background_texture = preload("res://Textures/seamless-starfield-texture.jpg")

export var system_size:= 5000

#Camera
var camera_node : Node2D
export var cam_move_speed := 1
var cam_zoom_speed := 1
var cam_move_dir := Vector2(0,0)

#Player
var player_node : Node2D
var player_ship : Node2D
var player_target : Node2D
var player_orbiting : bool 
var player_speed : float = 1
var time_in_orbit :int=0
signal enter_orbit


func _init() -> void:
	GameManager.scene_root = self
	


func _ready() -> void:
	
	self.connect("enter_orbit",self, "enter_orbit")
	camera_node = $Camera2D
	player_node = $Player
	player_ship = $Player/PlayerShip
	player_target = $Planets/Planet0
	setup_background()
	assign_player_to_planets()
	create_planets(49)
	$PulsePlayer.set_stream(GameManager.SongEcho)
	$PulsePlayer.play()

func _process(delta: float) -> void:
	cam_move(delta)
	player_move(delta)
	
	
	
	
func assign_player_to_planets() -> void:
	player_node = player_node
	for p in $Planets.get_children():
		p.player = player_node

func setup_background() -> void:
	var world_scalor : int = 10
	var v := Vector2(-system_size*world_scalor,-system_size*world_scalor)
	var tSize :Vector2 = background_texture.get_size()
	var layer0_scalor : float = 0.5
	var layer1_scalor : float = 0.3
	
	var layer0s : int = ((system_size *world_scalor * 2)/(tSize.x * layer0_scalor)) + 1
	var layer1s : int = ((system_size *world_scalor*2)/(tSize.x * layer1_scalor) ) + 1
	
	
	for i in layer0s:
		for j in layer0s:
			var scaledSize := tSize * layer0_scalor
			var layer0 := Sprite.new()
			layer0.scale *= layer0_scalor
			layer0.set_texture(background_texture)
			layer0.position = v + Vector2(i*scaledSize.x, j*scaledSize.y)
			$ParallaxBackground/ParallaxLayer0.add_child(layer0)
	for i in layer1s:
		for j in layer1s:
			var layer1 := Sprite.new()
			layer1.set_texture(background_texture)
			layer1.scale *= layer1_scalor
			var scaledSize := tSize * layer1_scalor
			layer1.position = v + Vector2(i*scaledSize.x, j*scaledSize.y)
			var c := CanvasItemMaterial.new()
			c.set_blend_mode(CanvasItemMaterial.BLEND_MODE_ADD)
			layer1.set_material(c)

			$ParallaxBackground/ParallaxLayer1.add_child(layer1)

func cam_move(delta) -> void:
	if player_orbiting:
		if Input.is_action_pressed("cam_left"):
			cam_move_dir.x -= 1*cam_move_speed*delta
		if Input.is_action_pressed("cam_right"):
			cam_move_dir.x += 1*cam_move_speed*delta
		if Input.is_action_pressed("cam_up"):
			cam_move_dir.y -= 1*cam_move_speed*delta
		if Input.is_action_pressed("cam_down"):
			cam_move_dir.y += 1*cam_move_speed*delta
	#	if Input.is_action_pressed("cam_zoom_in"):
	#		var z = cam_zoom_speed*delta
	#		camera_node.zoom -= Vector2(z,z)
	#		camera_node.zoom.x = clamp(camera_node.zoom.x,1,3)
	#		camera_node.zoom.y = clamp(camera_node.zoom.y,1,3)
	#	if Input.is_action_pressed("cam_zoom_out"):
	#		var z = cam_zoom_speed*delta
	#		camera_node.zoom -= Vector2(z,z)
	#		camera_node.zoom.x = clamp(camera_node.zoom.x,1,3)
	#		camera_node.zoom.y = clamp(camera_node.zoom.y,1,3)
		camera_node.position += cam_move_dir
	else:
		camera_node.position = camera_node.position.linear_interpolate(player_node.position, delta*cam_move_speed/2)+cam_move_dir
		cam_move_dir = Vector2.ZERO
	#Show line to player when off screen
	#var p0 :Vector2= player_target.position
	var p0 :Vector2= player_ship.global_position
	var p1 := get_global_mouse_position()
	$CameraToPlayer.set_point_position(0,p0)
	$CameraToPlayer.set_point_position(1,p1)
	
	if !$Player/PlayerShip/VisibilityNotifier2D.is_on_screen():
		if $CameraToPlayer.default_color.a <1.0:
			$CameraToPlayer.default_color.a += 0.01
	else:
		if $CameraToPlayer.default_color.a >0.0:
			$CameraToPlayer.default_color.a -= 0.01

	#camera_node.position = camera_node.position.linear_interpolate(player_node.position, delta*cam_move_speed/4)+cam_move_dir


func create_planets(_num:int) -> void:
	var secret_planets := 0
	for i in _num:
		var p := planet_card.instance()
		var pos1 := Vector2(rand_range(-system_size, system_size), rand_range(-system_size, system_size))
		#var pos := Vector2(1000*camera_node.zoom.x,1000*camera_node.zoom.y)
		var r:= rand_range(0,TAU)
		$PlanetPlacer.position = pos1
		if $PlanetPlacer/VisibilityNotifier2D.is_on_screen():
			p.position+=Vector2(2000,2000)
		else:
			p.position = pos1
		p.mass = rand_range(0.5, 200)
		p.density = rand_range(0.5, 5)
		if i %7 == 0:
			p.suit = GameManager.Suits.SECRET
			p.secret = GameManager.secrets[secret_planets]
			print("secret_planet_created: " + str(secret_planets))
			secret_planets += 1
		else:
			p.suit = randi() % (GameManager.Suits.size()-2)
		p.player = player_node
		$Planets.add_child(p)
		#print(str(i) + " planets created")
		yield(get_tree().create_timer(30), "timeout")
	print("planets done")
func player_move(delta) -> void:
	if player_orbiting:
		player_speed =2
	else:
		player_speed = 1
	#move player_node
	player_node.rotation += 0.1*delta
	player_node.position = player_node.position.linear_interpolate(player_target.position, delta*player_speed)
	
	#move player_ship
	var dir_to_target := player_target.position - player_node.position
	var dist := dir_to_target.length()
	dir_to_target = dir_to_target.normalized()
	var ship_dest := Vector2()
	
	#check orbit and adjust player ship
	if dist < 200:
		player_orbiting = true
		emit_signal("enter_orbit")
		ship_dest = dir_to_target * -player_target.size
		time_in_orbit +=1
	else:
		player_orbiting = false
		ship_dest = Vector2(0,0)
		time_in_orbit = 0
		
	player_ship.position = player_ship.position.linear_interpolate(ship_dest, delta*player_speed/2)


func enter_orbit()->void:
	if time_in_orbit < 100:
		player_target.nameValue.text = "IDENTIFYING-"+str(100-time_in_orbit)
		player_target.distValue.text = "ORBITING"
	elif time_in_orbit == 100:
		player_target.check_orbit()
	else:
		player_target.distValue.text = "ORBITING"# + str(time_in_orbit)
	
