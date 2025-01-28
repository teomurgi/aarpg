extends Node2D


func _ready() -> void:
	visible = false
	if PlayerManager.player_spawned == false:
		PlayerManager.setPlayerPosition(global_position)
		PlayerManager.player_spawned = true
		
		

