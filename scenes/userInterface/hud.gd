extends VBoxContainer

@onready var health_box_container: HBoxContainer = $HealthBoxContainer

const HEALTH_ICON = preload("uid://t2v55iowkeoe") # Cherry.tscn

func _ready():
	Event.connect("health_changed", _on_healthChanged)

func _on_healthChanged(old_health, new_health, max_health) -> void:
	var lives_left = health_box_container.get_child_count()
	
	if old_health > new_health:
		while new_health < lives_left and lives_left > 0:
			health_box_container.remove_child(health_box_container.get_child(lives_left -1))
			lives_left -= 1
	else:
		while lives_left < new_health and lives_left <= max_health:
			var cherry = HEALTH_ICON.instantiate()
			health_box_container.add_child(cherry)
			lives_left += 1
