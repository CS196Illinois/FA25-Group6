extends Node2D

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $"../sleep_screen/AnimationPlayer"
@onready var area_2d: Area2D = $Area2D
@onready var player: CharacterBody2D = $"../player"
var player_in_range: bool = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in_range = true
	label.show()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_range = false
	label.hide()

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		print("Sleeping...")
		animation_player.play("fade_to_black")
		player.get_node("AnimatedSprite2D").play("idle")
		player.set_process_input(false)
		player.set_physics_process(false)
		area_2d.monitoring = false
		await animation_player.animation_finished
		
		# Call sleep function here to end day
		await get_tree().create_timer(1.0).timeout
		
		animation_player.play("fade_in_from_black")
		await get_tree().create_timer(0.5).timeout
		player.set_process_input(true)
		player.set_physics_process(true)
		area_2d.monitoring = true
