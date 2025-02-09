@tool
@icon("res://Npc/Icons/npc.svg")
class_name NPC extends CharacterBody2D

signal do_behavior_enabled

@export var npc_resource: NpcResource = null: set = _set_npc_resource

var state: String = "idle"
var direction: Vector2 = Vector2.DOWN
var direction_name: String = "down"
var do_behavior: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
    setup_npc()
    if Engine.is_editor_hint():
        return
    do_behavior_enabled.emit()

func _physics_process(_delta: float) -> void:
    move_and_slide()

func update_animation() -> void:
    animation_player.play(state + "_" + direction_name)

func update_direction(target_position: Vector2) -> void:
    direction = global_position.direction_to(target_position)
    update_direction_name()
    if direction_name == "side" and direction.x < 0:
        sprite.flip_h = true
    else:
        $Sprite2D.flip_h = false
    
func update_direction_name() -> void:    
    var threshold:float = 0.45
    if direction.y < -threshold:
        direction_name = "up"
    elif direction.y > threshold:
        direction_name = "down"
    elif direction.x < -threshold or direction.x > threshold:
        direction_name = "side"

func setup_npc() -> void:
    if npc_resource and sprite:
        sprite.texture = npc_resource.sprite


func _set_npc_resource(_value: NpcResource) -> void:
    npc_resource = _value
    setup_npc()