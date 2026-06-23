extends CharacterBody2D

signal health_changed(current, max)

@export var speed: float = 300.0
@export var max_health: int = 100

var health: int

func _ready():
	health = max_health
	emit_signal("health_changed", health, max_health)

func _physics_process(delta):
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()

func take_damage(amount: int):
	health = max(health - amount, 0)
	emit_signal("health_changed", health, max_health)

	if health == 0:
		die()

func die():
	get_tree().reload_current_scene()
