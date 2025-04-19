extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_cooldown: Timer = $JumpCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var face_changer: Timer = $FaceChanger

@export var jump_impulse = 40.0

var attack_enemy: bool = false
var just_jumped: bool = false
var direction: int


func _ready() -> void:
	animation_player.play("left")

func _on_attack_box_component_chase_begun(new_direction: Variant) -> void:
	direction = new_direction
	attack_enemy = true
	update_facing_direction()

func _on_attack_box_component_chase_ended() -> void:
	attack_enemy = false

func update_facing_direction() -> void:
	if direction > 0:
		animation_player.play("right")
	elif direction < 0:
		animation_player.play("left")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY
	update_animation()
	jump_chase_movement()
	move_and_slide()
	if just_jumped and jump_cooldown.is_stopped() and is_on_floor():
		velocity = Vector2.ZERO
		jump_cooldown.start()
	if not just_jumped and jump_cooldown.is_stopped() and is_on_floor() and face_changer.is_stopped():
		face_changer.start()
		
func update_animation() -> void:
	if velocity.y > 0 and not is_on_floor():
		animated_sprite_2d.play("fall")
	else:
		animated_sprite_2d.play("idle")

func jump_chase_movement() -> void:
	if attack_enemy and is_on_floor() and not just_jumped:
		velocity = Vector2(direction * SPEED, jump_impulse)
		animated_sprite_2d.play("hop")
		just_jumped = true

func _on_jump_cooldown_timeout() -> void:
	just_jumped = false

func _on_face_changer_timeout() -> void:
	if is_on_floor():
		direction = randi_range(-10,10)
		update_facing_direction()
