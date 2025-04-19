extends Collectables

@export var value: int = 100

func _ready():
	body_entered.connect(_on_coin_collected)
	
func _on_coin_collected(body) -> void:
	if body is Player:
		item_collected()
		Event.emit_signal("coin_collected", value)
