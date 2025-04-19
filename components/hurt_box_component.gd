extends Area2D
## Requires a CollisionShape2D and Timer nodes for detection area and invicibility timing
class_name HurtBox

@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer

func _ready():
	self.connect("area_entered", _on_body_entered)
	timer.timeout.connect(_invincibility_timeout)

func _on_body_entered(hitbox: HitBox) -> void:
	if owner.has_method("take_damage") and timer.is_stopped():
		_invincibility_start()
		owner.take_damage(hitbox.damage, hitbox)

func _invincibility_timeout() -> void:
	collision_shape_2d.disabled = false

func _invincibility_start() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	timer.start()
