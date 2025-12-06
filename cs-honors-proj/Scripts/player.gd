extends CharacterBody2D

class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -200.0

func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)

func _on_spawn(position: Vector2, direction: String):
	global_position = position
	# animation_player.play("move_" + direction)


func _physics_process(delta: float) -> void:
	# Don't process movement if dialog is active
	var is_dialog_active = Dialogic.current_timeline != null

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Only handle input if dialog is not active
	if not is_dialog_active:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# Stop horizontal movement during dialog
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
