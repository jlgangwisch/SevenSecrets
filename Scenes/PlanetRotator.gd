extends Viewport

var r_speed := randf()
var r_dir := (randi() % 2) - 1
var planet_mesh : Node
var camera : Node
func _ready():

	randomize()
	camera = $PlanetTextureTaker
	planet_mesh = $PlanetMesh
	camera.rotate_z(randf())
	r_speed *= r_dir

	create_mesh(5)


	

func _process(delta: float) -> void:
	planet_mesh.rotate_y(r_speed*delta)

func create_mesh(_suit:int) -> void:

	var img : Texture
	match _suit:
		0,1,2,3,4:
			var diff_planets = GameManager.planet_textures.size()
			img = GameManager.planet_textures[randi()%diff_planets]
			
		5:
			img = load("res://Textures/sunmap.jpg")
	
	#var mesh := SphereMesh.new()
	var planet_material := SpatialMaterial.new()
	planet_material.albedo_texture = img
	planet_mesh.mesh.material = planet_material
	#planet_mesh.mesh = mesh


