extends Node

const PLAYER = preload("res://Player/player.tscn")

var player: Player
var player_spawned: bool = false

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func set_health(hp: int, max_hp: int) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp(0)

func set_player_position(_new_pos: Vector2) -> void:
	player.global_position = _new_pos

func reset_to_cardinal_direction(carinal_direction: Vector2) -> void:
	player.direction = Vector2.ZERO
	player.set_cardinal_direction(carinal_direction)

func set_as_parent(_node: Node) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_node.add_child(player)

func unparentPlayer(_p: Node2D) -> void:
	_p.remove_child(player)
