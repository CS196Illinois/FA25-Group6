extends Area2D
@onready var game_manager: Node = %GameManager
var player_in_area = false

func _on_body_entered(body: Node2D) -> void:
	player_in_area = true

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		game_manager.add_point()


func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
