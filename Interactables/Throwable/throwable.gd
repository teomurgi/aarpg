class_name Throwable extends Area2D

@export var gravity_strength: float = 980.0
@export var throw_speed: float = 400.0
@export var throw_height_strength: float = 100.0
@export var throw_starting_heigth: float = 49.0

var picked_up: bool = false
var throwable: Node2D
var throw_direction: Vector2 = Vector2.ZERO

var object_sprite: Sprite2D
var vertical_velocity: float = 0.0
var ground_height: float = 0.0
var animation_player: AnimationPlayer

@onready var hurtbox: Hurtbox = $Hurtbox

func _ready() -> void:
    area_entered.connect(_on_area_enter)
    area_exited.connect(_on_area_exit)
    throwable = get_parent()
    setup_hurtbox()

    object_sprite = throwable.find_child("Sprite2D")
    ground_height = object_sprite.position.y
    animation_player = throwable.find_child("AnimationPlayer")

    set_physics_process(false)

func _physics_process(delta: float) -> void:
    object_sprite.position.y += vertical_velocity * delta
    if object_sprite.position.y >= ground_height:
        destroy()
    vertical_velocity += gravity_strength * delta
    throwable.position += throw_direction * throw_speed * delta

func player_interact() -> void:
    if PlayerManager.interact_handled == true:
        return
    if picked_up == false:
        PlayerManager.interact_handled = true
        disable_collisions(throwable)
        if throwable.get_parent():
            throwable.get_parent().remove_child(throwable)
        PlayerManager.player.held_item.add_child(throwable)
        throwable.position = Vector2.ZERO
        PlayerManager.player.pickup_item(self)
        area_entered.disconnect(_on_area_enter)
        area_exited.disconnect(_on_area_exit)
        pass


func _on_area_enter(_a: Area2D) -> void:
    PlayerManager.interact_pressed.connect(player_interact)

func _on_area_exit(_a: Area2D) -> void:
    PlayerManager.interact_pressed.disconnect(player_interact)

func setup_hurtbox() -> void:
    hurtbox.monitoring = false
    for c in get_children():
        if c is CollisionShape2D:
            var _col: CollisionShape2D = c.duplicate()
            hurtbox.add_child(_col)
            _col.debug_color = Color(1, 0, 0, 0.5)

func throw() -> void:
    throwable.get_parent().remove_child(throwable)
    PlayerManager.player.get_parent().call_deferred("add_child", throwable)
    throwable.position = PlayerManager.player.position
    object_sprite.position.y = -throw_starting_heigth
    vertical_velocity = -throw_height_strength
    set_physics_process(true)
    hurtbox.set_deferred("monitoring", true)
    hurtbox.did_damage.connect(destroy)

func drop() -> void:
    throwable.get_parent().remove_child(throwable)
    PlayerManager.player.get_parent().call_deferred("add_child", throwable)
    throwable.position = PlayerManager.player.position
    object_sprite.position.y = -50.0
    vertical_velocity = -200.0
    throw_speed = 100.0
    set_physics_process(true)
    hurtbox.monitoring = true

func destroy() -> void:
    set_physics_process(false)
    if animation_player:
        animation_player.play("destroy")
        await animation_player.animation_finished
    throwable.queue_free()

func disable_collisions(_node: Node) -> void:
    for c in _node.get_children():
        if c == self:
            continue
        if c is CollisionShape2D:
            c.disabled = true
        else:
            disable_collisions(c)
