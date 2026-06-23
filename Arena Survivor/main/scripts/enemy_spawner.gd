extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_radius := 600.0
@export var min_spawn_radius := 450.0
@export var max_spawn_radius := 650.0
@export var player: Node2D

var timer := 0.0

func _process(delta):
	if player == null or enemy_scene == null:
		return
	
	timer += delta
	
	if timer >= spawn_interval:
		timer = 0.0
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()

	var angle = randf() * TAU
	var radius = randf_range(min_spawn_radius, max_spawn_radius)
	var offset = Vector2(cos(angle), sin(angle)) * radius

	enemy.global_position = player.global_position + offset
	enemy.player = player
	add_child(enemy)
	
	get_parent().add_child(enemy)
