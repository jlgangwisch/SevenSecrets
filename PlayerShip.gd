extends Node2D
class_name PlayerShip

export var sails := 20
#export var goal_path : NodePath
#var goal : Node2D
#var mag : float = 0
#export var max_velocity := 100

func _ready():
	for i in sails:
		var s := Sail.new()
		add_child(s)
#	goal = get_node(goal_path)

#func _physics_process(delta: float) -> void:
#	get_parent().rotation += 0.1*delta
#	var vel = get_travel_direction(goal.position)
#	get_parent().position+= vel 
#	#print(get_parent().position)
#	pass
#
#func get_travel_direction(_goal:Vector2)->Vector2:
#	var dir: Vector2 = _goal - get_parent().position
#	mag = dir.length()
#	dir= dir.normalized()
#	return dir
