extends HBoxContainer

@onready var heart1 = $Hear1/Sprite2D
@onready var heart2 = $Hear2/Sprite2D
@onready var heart3 = $Hear3/Sprite2D

var hearts = []
var player = null

func _ready():
	hearts = [heart1, heart2, heart3]
	# Find the player and connect to their health signal
	await get_tree().process_frame  # Wait one frame for player to be ready
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(_on_player_health_changed)
		update_hearts(player.currentHealth)  # Initialize with current health

func _on_player_health_changed(new_health: int):
	update_hearts(new_health)

func update_hearts(current_health: int):
	# Show/hide hearts - background always shows (empty heart outline)
	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].visible = true  # Show full heart
		else:
			hearts[i].visible = false  # Hide heart, leaving empty outline
