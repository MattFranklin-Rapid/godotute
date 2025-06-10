extends Button

@onready var start_button: Button = $"."

func _ready():
	start_button.pressed.connect(_button_pressed)

func _button_pressed():
	#get_tree().change_scene_to_file("uid://bs51eubaxo8ha") #Test Level
	get_tree().change_scene_to_file("uid://c34akfbxthxqd") #Test Level 2
