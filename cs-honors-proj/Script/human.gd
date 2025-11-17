extends Node2D
var speed = 50
var original_speed = 50  # Store original speed for restoring after dialogue
var direction = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_talking = false  # Track if NPC is in dialogue

#for moving
func _process(delta: float) -> void:
	position.x += speed * delta * direction
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	#delete human when they walk outside the boundry
	if position.x < -550 or position.x > 600:
		queue_free()
		
#for interacting
var player_enter = false #check player enter the body
var be_scared = false # ensure only change direction once
@onready var coin_scene: PackedScene = preload("res://Scene/coin.tscn")
var first = true #check for interact second time
@onready var hurt_sounds: AudioStreamPlayer = $hurt

# Dialogue system
var has_talked = false # track if player has talked to this NPC
var npc_dialogues = ["npc_chat_1", "npc_chat_2", "npc_chat_3", "npc_chat_4", "npc_chat_5", "npc_chat_6", "npc_chat_7", "npc_chat_8"]
var npc_dialogues_int_9 = ["npc_chat_1_int_9", "npc_chat_2_int_9", "npc_chat_3_int_9", "npc_chat_4_int_9", "npc_chat_5_int_9", "npc_chat_6_int_9", "npc_chat_7_int_9", "npc_chat_8_int_9"]
var npc_dialogues_int_7 = ["npc_chat_1_int_7", "npc_chat_2_int_7", "npc_chat_3_int_7", "npc_chat_4_int_7", "npc_chat_5_int_7", "npc_chat_6_int_7", "npc_chat_7_int_7", "npc_chat_8_int_7"]
var npc_dialogues_int_5 = ["npc_chat_1_int_5", "npc_chat_2_int_5", "npc_chat_3_int_5", "npc_chat_4_int_5", "npc_chat_5_int_5", "npc_chat_6_int_5", "npc_chat_7_int_5", "npc_chat_8_int_5"]
var npc_dialogues_low_int = ["npc_chat_1_low_int", "npc_chat_2_low_int", "npc_chat_3_low_int", "npc_chat_4_low_int", "npc_chat_5_low_int", "npc_chat_6_low_int", "npc_chat_7_low_int", "npc_chat_8_low_int"]

# Intelligence system - gradual scaling
var player_ref = null  # Reference to player

#check player's position
func _on_area_2d_body_entered(body: Node2D) -> void:
	player_enter = true
	# Store player reference if this is the player
	if body is CharacterBody2D:
		player_ref = body
func _on_area_2d_body_exited(body: Node2D) -> void:
	player_enter = false

func _physics_process(delta: float) -> void:
	# Talk to NPC with "Talk" button (separate from beat)
	# Only start dialogue if not already in one
	if Input.is_action_just_pressed("Talk") and player_enter and !has_talked and !GameManager.is_dialogue_active:
		has_talked = true
		is_talking = true
		GameManager.is_dialogue_active = true  # Mark dialogue as active
		# Stop NPC movement during dialogue
		original_speed = speed
		speed = 0

		# Pick a random dialogue index
		var random_index = randi() % npc_dialogues.size()
		var random_dialogue = ""

		# Gradual intelligence-based dialogue selection
		if player_ref:
			var player_int = player_ref.intelligence
			if player_int <= 4:
				# Very low intelligence (0-4): Almost all gibberish
				random_dialogue = npc_dialogues_low_int[random_index]
			elif player_int <= 6:
				# Low-medium intelligence (5-6): Only ~2 words readable
				random_dialogue = npc_dialogues_int_5[random_index]
			elif player_int <= 8:
				# Medium intelligence (7-8): About half readable
				random_dialogue = npc_dialogues_int_7[random_index]
			elif player_int == 9:
				# High-medium intelligence (9): Only ~2 words unreadable
				random_dialogue = npc_dialogues_int_9[random_index]
			else:
				# High intelligence (10+): Fully readable
				random_dialogue = npc_dialogues[random_index]
		else:
			# No player reference - default to normal dialogue
			random_dialogue = npc_dialogues[random_index]

		# Start the dialogue
		Dialogic.start(random_dialogue)
		# Connect to dialogue end signal to resume movement
		Dialogic.timeline_ended.connect(_on_dialogue_ended)

	# Original beat/scare mechanic on "interact" button (K key)
	if Input.is_action_just_pressed("interact") and player_enter:
		hurt_sounds.play()
		if (!be_scared):
			#check first beat
			be_scared = true
			#chang direction and run away faster
			direction = -1 * direction
			speed = 150
			animated_sprite_2d.play("runaway")
		elif (first):
			#check second beat and ensure no more reaction after second beat
			first = false
			#turn back and play animation
			direction = -1 * direction
			animated_sprite_2d.play("beat")
			speed = 0
			await animated_sprite_2d.animation_finished
			#play hit animation
			var new_coin = coin_scene.instantiate() # throw away new coin
			new_coin.position = self.position + Vector2(direction * 30, -10)
			# create coin on the ground and at back of the human
			get_node("/root/GameManager").add_child(new_coin)
			#create coin under gameManager to ensure the score is added
			animated_sprite_2d.play("runaway")
			direction = -1 * direction
			speed = 300 #run away faster and faster

# Called when dialogue ends to resume NPC movement
func _on_dialogue_ended():
	is_talking = false
	speed = original_speed  # Restore original walking speed
	GameManager.is_dialogue_active = false  # Mark dialogue as inactive
	Dialogic.timeline_ended.disconnect(_on_dialogue_ended)  # Clean up signal connection
