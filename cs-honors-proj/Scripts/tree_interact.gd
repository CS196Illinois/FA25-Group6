extends Area2D
var player_in_area = false

func _on_body_entered(body: Node2D) -> void:
	print("here")
	player_in_area = true

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/dorm_room.tscn")
