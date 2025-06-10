extends Actors
class_name Player

signal game_over

@export var JUMPSPEED: float = 200.0
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var cyote_timer: Timer = $"Cyote Timer"

const MAX_FALL_SPEED = 245.0 * 3
var INITIAL_GRAVITY = 0

var is_cyote_time = false
var can_jump = true
var was_on_ground = true
var horizontal_push = 0.0

const MAX_HEALTH = 5
var player_health: int = 5
var start_position: Vector2

func _ready():
	start_position = global_position
	INITIAL_GRAVITY = GRAVITY

## Pushes falling velocity to max and resets on landing
func push_fall(delta) -> void:
	if not is_on_floor() and velocity.y > 0 and GRAVITY < MAX_FALL_SPEED:
		var deltaGrav = MAX_FALL_SPEED - GRAVITY
		GRAVITY += deltaGrav * delta
	if is_on_floor() and GRAVITY != INITIAL_GRAVITY:
		GRAVITY = INITIAL_GRAVITY
	# Fall 💀
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif is_on_floor():
		velocity.y = 0

## Controls if jump is available, accounts for cyote time and wall jumps
func update_jump_available(delta) -> void:
	if is_on_floor() or is_on_wall():
		can_jump = true
		was_on_ground = true
	else:
		if was_on_ground and cyote_timer.is_stopped():
			was_on_ground = false
			cyote_timer.start()

## Updates can jump status when cyote time expires
func _on_cyote_timer_timeout() -> void:
	if not is_on_floor() and not is_on_wall():
		can_jump = false

## Deals with jumping physics
func handle_jump(delta, direction) -> void:
	velocity.y = 0.0
	velocity.y = -JUMPSPEED
	if is_on_wall():
		horizontal_push = -JUMPSPEED * direction * 2
	animated_sprite_2d.play("track" if velocity.y > 0 else "idle")

## Handles physics for moving sideways, including knockback
func handle_horizontal_motion(delta, direction):
	#Get pushed back and ignore inputs
	if horizontal_push != 0.0:
		print('Get Pushed')
		print(horizontal_push)
		velocity.x = horizontal_push
		if horizontal_push < 10.0 and horizontal_push > -10.0:
			horizontal_push = 0.0
		else:
			horizontal_push = horizontal_push / 1.3
	#Otherwise move the given input
	elif direction:
		velocity.x = (direction * SPEED)
	#Otherwise slowly slide down to 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	push_fall(delta)
	update_jump_available(delta)
	if Input.is_action_just_pressed("jump") and can_jump:
		handle_jump(delta, direction)
	else:
		animated_sprite_2d.play("walk" if direction else "idle")
	handle_horizontal_motion(delta, direction)
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
	
	#global_position = start_position
	#animated_sprite_2d.play("idle")
	var old_health = player_health
	Event.emit_signal("health_changed", old_health, MAX_HEALTH, MAX_HEALTH)
	player_health = MAX_HEALTH
	get_tree().change_scene_to_file("uid://bs51eubaxo8ha") #Test Level
	
