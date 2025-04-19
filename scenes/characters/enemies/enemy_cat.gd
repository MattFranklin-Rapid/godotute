extends Enemy

@onready var danger_detector_left:RayCast2D = $DangerDetectorLeft
@onready var danger_detector_right:RayCast2D = $DangerDetectorRight
@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer

const WALK_SPEED = 40.0
const RUN_SPEED = 70.0
const FRAME_SPEED_SCALE = 0.3
const DETECTION_COOLDOWN = 2
var detection_time = 0

func _ready():
	animated_sprite_2d.speed_scale = 1.0
	velocity.x = WALK_SPEED * (-1 if randi_range(0,1) else 1)

func _on_attack_box_component_chase_begun(new_direction: Variant) -> void:
	animated_sprite_2d.speed_scale += FRAME_SPEED_SCALE
	SPEED = RUN_SPEED
	velocity.x = new_direction * SPEED

func _on_attack_box_component_chase_ended() -> void:
	animated_sprite_2d.speed_scale -= FRAME_SPEED_SCALE
	SPEED = WALK_SPEED
	velocity.x = SPEED

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY
	calculate_move_velocity()
	animation_player.play("move_right" if velocity.x > 0 else "move_left")
	move_and_slide()

func take_damage(amount, body) -> void:
	if body.global_position.y > get_node("HurtBox").global_position.y:
		return
	print("🙀")
	die()

func calculate_move_velocity() -> void:
	if not danger_detector_left.is_colliding() or \
	(danger_detector_left.is_colliding() and danger_detector_left.get_collider() is Spike):
		velocity.x = velocity.x * -1
	
	if is_on_wall():
		velocity.x = get_wall_normal().x * SPEED
