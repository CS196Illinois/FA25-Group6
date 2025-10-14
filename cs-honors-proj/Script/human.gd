extends Node2D
var speed = 50
var direction = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#for moving
func _process(delta: float) -> void:
	position.x += speed * delta * direction
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	if position.x < -550 or position.x > 600:
		queue_free()
		
#for interacting
var player_enter = false #check player enter the body
var be_scared = false # ensure only change direction once
@onready var coin_scene: PackedScene = preload("res://Scene/coin.tscn")
var first = true 
@onready var hurt_sounds: AudioStreamPlayer = $hurt

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_enter = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	player_enter = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_enter:
		hurt_sounds.play()
		if (!be_scared):
			be_scared = true
			direction = -1 * direction
			speed = 150
			animated_sprite_2d.play("runaway")
		elif (first):
			first = false
			direction = -1 * direction
			animated_sprite_2d.play("beat")
			speed = 0
			await animated_sprite_2d.animation_finished
			#play hit animation
			var new_coin = coin_scene.instantiate() # create new coin
			new_coin.position = self.position + Vector2(direction * 30, -10) 
			# create coin on the ground and at back of the human
			get_node("/root/GameManager").add_child(new_coin) 
			#create coin under gameManager to ensure the score is added
			animated_sprite_2d.play("runaway")
			direction = -1 * direction
			speed = 300 #run away faster
			
