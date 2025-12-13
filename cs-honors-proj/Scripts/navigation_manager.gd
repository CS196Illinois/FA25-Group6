extends Node

const scene_foellinger = preload("res://scenes/foellinger.tscn")
const scene_quad = preload("res://scenes/quad.tscn")
const scene_union = preload("res://scenes/union.tscn")
const scene_green_st = preload("res://scenes/games.tscn")
const scene_siebel = preload("res://scenes/siebel.tscn")

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
		"games":
			scene_to_load = scene_green_st
		"siebel":
			scene_to_load = scene_siebel
		
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
		
func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
