extends Node

const PLAYER = preload("res://Player/player.tscn")

var player: Player
var player_spawned: bool = false

func _ready() -> void:
    addPlayerInstance()
    await get_tree().create_timer(0.2).timeout
    player_spawned = true

func addPlayerInstance() -> void:
    player = PLAYER.instantiate()
    add_child(player)

func setPlayerPosition(_new_pos: Vector2) -> void:
    player.global_position = _new_pos

func setAsParent(_node: Node) -> void:
    if player.get_parent():
        player.get_parent().remove_child(player)
    _node.add_child(player)

func unparentPlayer(_p: Node2D) -> void:
    _p.remove_child(player)