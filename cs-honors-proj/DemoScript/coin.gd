extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#check if player attach the body
func _on_body_entered(body: Node2D) -> void:
	#adding count
	GameManager.add_point()
	#delete coin according the set in animationPlayer
	animation_player.play("pickup")
