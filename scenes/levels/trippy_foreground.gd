extends TileMapLayer

@onready var player: Player = $"../Player"
var myMaterial: ShaderMaterial

func _ready():
	myMaterial = self.get_material()

func _physics_process(delta: float) -> void:
	var playerLoc = player.global_position.x
	playerLoc = playerLoc / 300.0
	playerLoc = fmod(playerLoc, 300.0)
	myMaterial.set_shader_parameter("h", playerLoc)
