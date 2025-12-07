extends CharacterBody2D

class_name Player

signal health_changed(new_health)

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var playing = false
var birth_position: Vector2

@export var inv: Inv

var strength = 10
var intelligence = 6
var agility = 10

var health = 3
@onready var currentHealth = health:
	set(value):
		currentHealth = clamp(value, 0, health)
		health_changed.emit(currentHealth)

# Knockback
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay: float = 0.8

# Double Jump
var double_jump_unlocked = true
var max_jumps = 1
var current_jumps = 0

func _ready():
	birth_position = position
	#get birth position for killzone
	if double_jump_unlocked:
		max_jumps = 2
func respawn():
	position = birth_position
	velocity = Vector2.ZERO

func take_damage(amount: int = 1, knockback_direction: Vector2 = Vector2.ZERO):
	currentHealth -= amount
	if currentHealth <= 0:
		die()
	else:
		# Apply knockback
		if knockback_direction != Vector2.ZERO:
			knockback_velocity = knockback_direction * 400.0

func die():
	# Reset health and respawn
	currentHealth = health
	respawn()

func _physics_process(delta: float) -> void:
	# Don't process movement if dialog is active
	var is_dialog_active = Dialogic.current_timeline != null

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		current_jumps = 0
	#avoid moving during the dialog
	if GameManager.is_in_dialogue:
		playing = false
		velocity.x = 0
		move_and_slide()
		return

	# Apply knockback velocity
	if knockback_velocity.length() > 0:
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, knockback_decay)
		if knockback_velocity.length() < 10:
			knockback_velocity = Vector2.ZERO

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or current_jumps < max_jumps):
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
