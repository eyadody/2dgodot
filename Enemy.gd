extends CharacterBody2D

@export var speed: float
@export var deathSprite: Texture2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D

var is_dead = false
var timer = 1.0
var timerStarted: bool = false


func _physics_process(delta):

	if timerStarted:
		timer -= delta

		if timer <= 0:
			queue_free()

	else:
		velocity.x = speed
		move_and_slide()


func _on_wall_detector_body_entered(body):
	if not is_dead:
		speed = -speed


func _on_player_detector_body_entered(body):
	if body is Player and not is_dead:
		die()


func die():
	if is_dead:
		return

	is_dead = true

	collision_shape_2d.queue_free()

	# Disable all enemy detection areas
	for child in get_children():
		if child is Area2D:
			child.queue_free()

	sprite_2d.texture = deathSprite
	velocity.x = 0
	timerStarted = true
