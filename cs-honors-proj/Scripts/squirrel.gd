extends CharacterBody2D

const CLIMABLE_LAYER = "is_climable"
const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const ATTACK_VELOCITY = 10

@onready var cooldown_timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var on_climb: bool
var climbing: bool
var can_attack = true
var last_dir = 1.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	on_climb = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	on_climb = false

func _ready():
	# attack cooldown timer
	cooldown_timer.wait_time = 0.5
	cooldown_timer.one_shot = true
	cooldown_timer.connect("timeout", _on_cooldown_timer_timeout)
	
func _on_cooldown_timer_timeout():
	can_attack = true
	
func _physics_process(delta: float) -> void:
	var grounded = is_on_floor()
	
# horizontal direction: -1, 0, 1
	var horizontal_dir = Input.get_axis("left", "right")
	# flip sprite based on left right
	if (horizontal_dir > 0):
		animated_sprite.flip_h = false
	elif (horizontal_dir < 0):
		animated_sprite.flip_h = true
	# keep track of last moved direction
	if (not horizontal_dir == 0.0): last_dir = horizontal_dir
	
# horizontal movement input
	if horizontal_dir:
		velocity.x = horizontal_dir * SPEED
		if on_climb: climbing = not grounded
		else: climbing = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
# horizontal movement animation
	if (horizontal_dir == 0 && (grounded || climbing)):
		animated_sprite.play("squirrel_idle")
	elif (grounded || climbing):
		animated_sprite.play("squirrel_run")
	else:
		animated_sprite.play("squirrel_jump")
		
# climbing movement up down
	if on_climb:
		# vertical direction: -1, 0, 1
		var vertical_dir = Input.get_axis("up", "down")
		# vertical climbing movement input
		if vertical_dir:
			velocity.y = vertical_dir * SPEED
			climbing = not grounded
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
# Apply gravity when jumping
	elif not grounded:
		velocity += get_gravity() * delta
	
# Handle jump --> NEED TO FIX CLIMBING JUMP
	if Input.is_action_just_pressed("jump") and (is_on_floor() or climbing):
		velocity.y = JUMP_VELOCITY
	
# attack input --> NEED TO FIX
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			can_attack = false
			# attack
			print("attack")
			cooldown_timer.start()
	
	move_and_slide()
