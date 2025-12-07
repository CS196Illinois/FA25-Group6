extends AnimatableBody2D

@export var move_speed: float = 50.0
@export var move_distance: float = 100.0
@export var damage_amount: int = 1
@export var animation_speed: float = 10.0  # Frames per second

var start_position: Vector2
var move_direction: int = 1  # 1 for right, -1 for left
var time_elapsed: float = 0.0
var animation_time: float = 0.0
@onready var sprite = $Sprite2D

func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	# Use sine wave for smooth back and forth motion
	time_elapsed += delta
	var movement_factor = sin(time_elapsed * move_speed / move_distance * PI)
	var new_x = start_position.x + movement_factor * move_distance

	# Flip sprite based on movement direction
	if new_x > position.x:
		sprite.flip_h = true  # Moving right
	elif new_x < position.x:
		sprite.flip_h = false   # Moving left

	position.x = new_x

	# Animate the bird sprite
	animation_time += delta
	var frame_duration = 1.0 / animation_speed
	sprite.frame = int(animation_time / frame_duration) % sprite.hframes

func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name, " - Has take_damage: ", body.has_method("take_damage"))
	if body.has_method("take_damage"):
		# Calculate knockback direction from hazard to player
		var knockback_dir = (body.global_position - global_position).normalized()
		body.take_damage(damage_amount, knockback_dir)
		print("Hazard dealt ", damage_amount, " damage to player with knockback!")
