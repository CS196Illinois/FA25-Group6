extends Area2D

var player_into_area = false
var first_interact = true
func _on_body_entered(body: Node2D) -> void:
	player_into_area = true
func _process(delta):
	if player_into_area and Input.is_action_just_pressed("interact") and first_interact:
		first_interact = false
		Dialogic.start("greetTrashBin")
	elif player_into_area and Input.is_action_just_pressed("interact") and !first_interact:
		Dialogic.start("talkAgain")
