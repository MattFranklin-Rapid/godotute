extends Actors

class_name Enemy

@export var mob_point: int = 10
const ENEMYDEATHEFFECT = preload("uid://vtgc2swo22y0") #Enemy Death Effect.tscn

func create_death_effect() -> void:
	var enemeyDeathEffect = ENEMYDEATHEFFECT.instantiate()
	get_parent().add_child(enemeyDeathEffect)
	enemeyDeathEffect.global_position = global_position

func die() -> void:
	queue_free()
	create_death_effect()
