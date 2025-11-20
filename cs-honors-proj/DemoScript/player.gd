extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var playing = false
var birth_position: Vector2

func _ready():
	birth_position = position
	#get birth position for killzone
func respawn():
	position = birth_position
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	# flip the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	# play animations each time when press "K" without loop
	if Input.is_action_pressed("interact") and is_on_floor() and !playing:
		animated_sprite_2d.play("beat")
		await animated_sprite_2d.animation_finished
		playing = true
	elif Input.is_action_just_released("interact") and is_on_floor():
		playing = false;
	#static state, normal run and jump
	if is_on_floor() and !playing:
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	#apply movement
	if !playing :
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0
		#avoid moing when interact
	move_and_slide()
