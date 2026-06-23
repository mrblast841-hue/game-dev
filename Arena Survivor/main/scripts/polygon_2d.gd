@tool
extends Polygon2D

@export var radius := 8
@export var points := 24

func _ready():
	update_circle()

func _process(_delta):
	if Engine.is_editor_hint():
		update_circle()

func update_circle():
	var poly := PackedVector2Array()
	for i in points:
		var angle = TAU * i / points
		poly.append(Vector2(cos(angle), sin(angle)) * radius)
	polygon = poly
