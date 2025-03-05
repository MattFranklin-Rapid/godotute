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
		print(velocity.y)
		velocity.y -= JUMPSPEED * delta
		print(velocity.y)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
