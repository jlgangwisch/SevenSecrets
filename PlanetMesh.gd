extends MeshInstance

class_name PlanetMesh

var sphere := SphereMesh.new()
var mat := SpatialMaterial.new()
var img : Texture
var Suits := GameManager.Suits

var r_speed := rand_range(0.5, 2)
var r_dir := (randi() % 2)

func _ready() -> void:
	if r_dir == 0:
		r_dir = -1
	r_speed *= r_dir * 0.1
	


func _process(delta: float) -> void:
	rotate_y(r_speed*delta)


func create_mesh(_suit:int) -> void:
	if _suit == Suits.SUN:
		img = load("res://Textures/sunmap.jpg")
		#print("sun")
	else:
		var diff_planets = GameManager.planet_textures.size()
		img = GameManager.planet_textures[int(rand_range(0,GameManager.planet_textures.size()-1))]
		#print("planet")
	mat.set_flag(SpatialMaterial.FLAG_UNSHADED, true)
	mat.set_texture(SpatialMaterial.TEXTURE_ALBEDO,img)
	sphere.set_material(mat)
	set_mesh(sphere)

