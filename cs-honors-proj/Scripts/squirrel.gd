extends CharacterBody2D

const CLIMABLE_LAYER = "is_climable"
const SPEED = 150.0
const JUMP_VELOCITY = -250.0

var on_climb: bool
var climbing: bool

func _on_area_2d_body_entered(body: Node2D) -> void:
	on_climb = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	on_climb = false

func _physics_process(delta: float) -> void:
	var grounded = is_on_floor()
	var horizontal_dir = Input.get_axis("left", "right")
	
	if on_climb:
		var vertical_dir = Input.get_axis("up", "down")
		if vertical_dir:
			velocity.y = vertical_dir * SPEED
			climbing = not grounded
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	# Apply gravity when jumping
	elif not grounded:
		velocity += get_gravity() * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or climbing):
		velocity.y = JUMP_VELOCITY
	
	# Movement input
	if horizontal_dir:
		velocity.x = horizontal_dir * SPEED
		if on_climb: climbing = not grounded
		else: climbing = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
