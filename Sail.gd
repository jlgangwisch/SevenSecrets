extends Node2D
class_name Sail

var rotation_speed := randf()
var radius := rand_range(20,100)
var a1 := rand_range(0,360)
var a2 := a1 + rand_range(10,90)
var color := rand_range(0.5,0.8)

func _ready():
	pass

func _process(delta: float) -> void:
	rotation += rotation_speed*delta

func _draw() -> void:
	draw_circle_arc_poly(Vector2(0,0),radius, a1, a2, Color(color,color,color))

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
	draw_circle(Vector2(0,0),20,Color(0,0,0))
