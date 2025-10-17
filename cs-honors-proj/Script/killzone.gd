extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	timer.start()
#check if player walk into the boundry

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
#reopen the game when walk against the boundry
