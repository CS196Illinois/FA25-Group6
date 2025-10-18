extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	timer.set_meta("target", body)
	#make something like map that save our body so that it's enable to call body in other function
	timer.start()
#check if player walk into the boundry

func _on_timer_timeout() -> void:
	var player = timer.get_meta("target")
	player.respawn()
#when walk against the boundry, move character back to the birth place
