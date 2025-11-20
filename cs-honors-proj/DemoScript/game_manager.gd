extends Node

#part for score(coin) collecting
@onready var score_label: Label = $ScoreLabel
var score = 0
var first_reach_amount = true;
#prevent repeated dialogue
func _ready():
	#connect autoload GameManager to find ScoreLabel
	score_label = get_tree().get_root().find_child("ScoreLabel", true, false)
	#connect dialogic signal and begining initial dialog
	Dialogic.signal_event.connect(_on_dialogic_signal)
	# Dialogic.start("beginning")

#count coins
func add_point():
	score += 1
	if score_label:
		score_label.text = "Coins: " + str(score)
#stop game when choose certain choice
func _on_dialogic_signal(argument: String):
	if argument == "stop_game":
		get_tree().quit()
		
# part for npc creating
@export var human_copy = preload("res://DemoScene/human.tscn")
@export var creat_cd := 3.0  # create humann each 3 seconds
@export var left_create_x := -550   # create outside left killzone
@export var right_create_x := 600   # create outside right killzone
@export var create_y := 80   # create on ground

var time_count = 0.0
#func create_human():
	#var human = human_copy.instantiate() # create new human scene
	#var random_side = randi() % 2 # create random 0 or 1, allows npc appear randomely in left or right
	#if random_side == 0 :
		##set original place and direction
		#human.position = Vector2(left_create_x, create_y);
		#human.direction = 1;
	#else:
		#human.position = Vector2(right_create_x, create_y);
		#human.direction = -1;
	#add_child(human) 
	#add our new human

#creat human each 3 seconds
#func _process(delta):
	#time_count += delta
	#if time_count >= creat_cd:
		#time_count = 0
		#create_human()
		
#add conditional dialog
	#if score == 10 and first_reach_amount:
		#first_reach_amount = false
		#Dialogic.start("coins collection")
		#
