extends Node


func _ready() -> void:
	var spawn_node := $Doors/Door_R/Spawn  
	match GlobalState.last_scene_name:
		"games":
			spawn_node = $Doors/Door_R/Spawn      
	$Player.global_position = spawn_node.global_position
	if NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
	return
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
