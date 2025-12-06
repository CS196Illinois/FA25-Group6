extends Area2D

@export_file("*.tscn") var next_scene_path : String = "res://Scenes/quad.tscn"

func _on_body_entered(body: Node2D) -> void:
	#change scene
	if body.name == "player": 
		get_tree().change_scene_to_file(next_scene_path)
