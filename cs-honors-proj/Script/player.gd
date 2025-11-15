extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var playing = false
var birth_position: Vector2

var strength = 10

# Double Jump Mechanic
var double_jump_unlocked = true
var max_jumps = 1
var current_jumps = 0


# Charged Jump Mechanic
const MAX_CHARGE_TIME = 1.5 # seconds
var charging = false
var charge_time = 0.0

func _ready():
	birth_position = position
	#get birth position for killzone
	if double_jump_unlocked:
		max_jumps = 2
func respawn():
	position = birth_position
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		current_jumps = 0
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() || current_jumps < max_jumps):
		velocity.y = JUMP_VELOCITY
		current_jumps += 1
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
