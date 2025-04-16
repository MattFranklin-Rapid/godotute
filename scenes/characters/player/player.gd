extends Actors
class_name Player

signal game_over

@export var JUMPSPEED: float = 150.0

@onready var animated_sprite_2d = $AnimatedSprite2D

const MAX_HEALTH = 3
var player_health: int = 3

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= JUMPSPEED * delta
		animated_sprite_2d.play("track" if velocity.y > 0 else "idle")
	else:
		animated_sprite_2d.play("walk" if direction else "idle")

	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_facing_direction()
	move_and_slide()

func update_facing_direction() -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true

func take_damage(amount) -> void:
	print("🔥")
