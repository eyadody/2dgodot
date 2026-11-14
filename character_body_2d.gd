
extends CharacterBody2D
class_name Player

const SPEED = 350.0
const JUMP_VELOCITY = -600.0

@onready var sfx_jump: AudioStreamPlayer2D = $sfx_jump
@onready var timer: Timer = $"../Timer"

var coin_counter = 0
@onready var coin_label = %Label

func respawn(): 
	$CollisionShape2D.queue_free()
	timer.start()
	

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()

	# Handle movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		$Sprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		set_coin(coin_counter + 1)
		print(coin_counter)

func set_coin(new_coin_count: int) -> void:
	coin_counter = new_coin_count
	coin_label.text = "Coins Collected " + str(coin_counter)


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
