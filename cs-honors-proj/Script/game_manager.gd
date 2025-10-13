extends Node
@onready var score_label: Label = $ScoreLabel
var score = 0
func _ready():
	#connect autoload GameManager to find ScoreLabel
	score_label = get_tree().get_root().find_child("ScoreLabel", true, false)
func add_point():
	score += 1
	if score_label:
		score_label.text = "Coins: " + str(score)
