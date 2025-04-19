extends Actors
class_name Player

signal game_over

@export var JUMPSPEED: float = 150.0

@onready var animated_sprite_2d = $AnimatedSprite2D

const MAX_HEALTH = 5
var player_health: int = 5
var start_position: Vector2

func _ready():
	start_position = global_position

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

func take_damage(amount, body) -> void:
	if body.get_parent() is Enemy:
		if body.global_position.y > get_node("HurtBox").global_position.y:
			return
	var old_health = player_health
	player_health -= amount
	Event.emit_signal("health_changed", old_health, player_health, MAX_HEALTH)
	if player_health - amount <= 0:
		revive()
	print("🔥")

func extra_live(amount) -> void:
	var old_health = player_health
	player_health += amount
	Event.emit_signal("health_changed", old_health, player_health, MAX_HEALTH)

func revive() -> void:
	global_position = start_position
	animated_sprite_2d.play("idle")
	var old_health = player_health
	Event.emit_signal("health_changed", old_health, MAX_HEALTH, MAX_HEALTH)
	player_health = MAX_HEALTH
	
