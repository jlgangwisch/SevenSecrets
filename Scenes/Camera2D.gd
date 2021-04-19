extends Camera2D

export var move_speed := 1
var zoom_speed := 1
var move_dir := Vector2(0,0)


func _ready():
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("cam_left"):
		move_dir.x -= 1*move_speed*delta
	if Input.is_action_pressed("cam_right"):
		move_dir.x += 1*move_speed*delta
	if Input.is_action_pressed("cam_up"):
		move_dir.y -= 1*move_speed*delta
	if Input.is_action_pressed("cam_down"):
		move_dir.y += 1*move_speed*delta
	if Input.is_action_pressed("cam_zoom_in"):
		var z = zoom_speed*delta
		zoom -= Vector2(z,z)
		zoom.x = clamp(zoom.x,1,3)
		zoom.y = clamp(zoom.y,1,3)
	if Input.is_action_pressed("cam_zoom_out"):
		var z = zoom_speed*delta
		zoom += Vector2(z,z)
		#zoom.x = clamp(zoom.x,0,3)
		#zoom.y = clamp(zoom.y,0,3)

	position+=move_dir
	#position.x = clamp(position.x,owner.system_size,owner.system_size)
	#position.y = clamp(position.y,owner.system_size, owner.system_size)
