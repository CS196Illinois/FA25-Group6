extends Node2D

@onready var label: Label = $Label
var player_in_range: bool = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in_range = true
	label.show()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_range = false
	label.hide()

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		print("Studying...")
		# Call sleep function here to end day
