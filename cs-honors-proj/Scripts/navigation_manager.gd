extends Node

const scene_foellinger = preload("res://scenes/foellinger.tscn")
const scene_quad = preload("res://scenes/quad.tscn")
const scene_union = preload("res://scenes/union.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"foellinger":
			scene_to_load = scene_foellinger
		"quad":
			scene_to_load = scene_quad
		"union":
			scene_to_load = scene_union
		
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
		
func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
