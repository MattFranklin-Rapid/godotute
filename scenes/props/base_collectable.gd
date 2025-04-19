extends Area2D
class_name Collectables

const ITEM_FEEDBACK = preload("uid://c6oay3bicq76g") #Item_feedback.tscn

func item_collected() -> void:
	queue_free()
	instance_item_feedback()
	
func instance_item_feedback() -> void:
	var item_effect = ITEM_FEEDBACK.instantiate()
	get_parent().add_child(item_effect)
	item_effect.global_position = global_position
