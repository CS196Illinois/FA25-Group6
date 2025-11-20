extends Area2D
@onready var game_manager: Node = %GameManager
var player_in_area = false
@onready var pickupsound: AudioStreamPlayer = $pickupsound
var first = true #test if player leave the trashbin before next interact
@onready var coin_scene: PackedScene = preload("res://DemoScene/coin.tscn")
var current_coin: Node = null #test if already have coin created
#add CD to pickup coins from trashbin
@onready var cd: Timer = $CD
var inCD = false

func _on_body_entered(body: Node2D) -> void:
	player_in_area = true

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact") and first and !inCD:
		#check all the requirement to create new coins
		first = false
		if current_coin and current_coin.is_inside_tree():
			return
			#avoid more coin if created coin didn't disappear
		else:
			cd.start()
			inCD = true
		#avoid frequently create coin
		var new_coin = coin_scene.instantiate() # create new coin
		new_coin.position = self.position + Vector2(0, -30) 
		# create coin on the top of the trash bin
		get_tree().current_scene.add_child(new_coin)
		pickupsound.play()
		current_coin = new_coin

#player must leave the area and come in again to create next coin
func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
	first = true


func _on_ten_seconds_timeout() -> void:
	inCD = false
	#ensure coins only created longer or equal than each 10s
