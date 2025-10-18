extends Control

func _ready() -> void:
	$MarginContainer/VBoxContainer/MenuOptions/ContinueButton.grab_focus()

func _on_continue_button_pressed() -> void:
	# USE THIS COMAMND TO CHANGE SCENE
	# get_tree().change_scene_to_file("NAME OF SCENE")
	print("Loading save files!")
	
func _on_new_game_button_pressed() -> void:
	print("Creating new game!")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_tutorial_button_pressed() -> void:
	# get_tree().change_scene_to_file("TUTORIAL SCENE")
	print("Tutorializing!")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
