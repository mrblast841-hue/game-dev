extends Area2D

@export var speed := 150.0

# Damage ramping
@export var base_damage := 10
@export var base_interval := 1.0
@export var min_interval := 0.25
@export var ramp_speed := 0.1

# Separation
@export var separation_strength := 80.0
@export var separation_radius := 40.0
@export var separation_growth := 0.5

# Spawn safety
@export var activation_delay := 0.6
@export var player: CharacterBody2D

@onready var separation_area: Area2D = get_node_or_null("SeparationArea")
@onready var collision := $CollisionShape2D

var current_interval := 1.0
var damage_timer := 0.0
var touching_player := false

func _ready():
	print("SeparationArea found:", separation_area)
	current_interval = base_interval

	collision.disabled = true
	monitoring = false

	await get_tree().process_frame
	await get_tree().create_timer(activation_delay).timeout

	collision.disabled = false
	monitoring = true

func _physics_process(delta):
	if separation_area == null:
		return
	if player == null:
		return

	# Grow separation radius slowly over time
	separation_radius = min(separation_radius + separation_growth * delta, 70.0)

	# Direction to player
	var to_player := (player.global_position - global_position).normalized()

	# Separation force
	var separation := get_separation_force()

	# FINAL movement = attraction + repulsion
	var velocity := to_player * speed + separation
	global_position += velocity * delta

	# Damage logic
	if touching_player:
		damage_timer += delta
		if damage_timer >= current_interval:
			damage_timer = 0.0
			player.take_damage(base_damage)
			current_interval = max(min_interval, current_interval - ramp_speed)
	else:
		damage_timer = 0.0

func _on_body_entered(body):
	if body == player:
		touching_player = true
		player.take_damage(base_damage)
		damage_timer = 0.0

func _on_body_exited(body):
	if body == player:
		touching_player = false
		damage_timer = 0.0
		current_interval = base_interval

func get_separation_force() -> Vector2:
	var force := Vector2.ZERO
	var count := 0

	for area in separation_area.get_overlapping_areas():
		var other: Area2D = area.get_parent()
		if other == self:
			continue

		var diff := global_position - other.global_position
		var dist := diff.length()

		if dist > 0 and dist < separation_radius:
			force += diff.normalized() / dist
			count += 1

	if count > 0:
		force /= count

	return force * separation_strength
