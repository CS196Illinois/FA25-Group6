extends Node2D
const speed = 50
var direction = 1
func _process(delta: float) -> void:
	position.x += speed * delta * direction
