class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurtbox: Hurtbox)
signal enemy_destroyed(hurtbox: Hurtbox)

const DIR_4 = [
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.UP
]

@export var hp: int = 3

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize(self)
	player = PlayerManager.player
	hitbox.damaged.connect(takeDamage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func setDirection(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false;
		
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_cardinal_direction: Vector2 = DIR_4[direction_id]
	
	if new_cardinal_direction == cardinal_direction:
		return false;
	cardinal_direction = new_cardinal_direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	direction_changed.emit(cardinal_direction)
	return true

func updateAnimation(state: String) -> void:
	animation_player.play(state + "_" + animationDirection())

func animationDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	if cardinal_direction == Vector2.UP:
		return "up"
	return "side"

func takeDamage(hurtbox: Hurtbox) -> void:
	if invulnerable == true:
		return
	hp -= hurtbox.damage
	if hp > 0:
		enemy_damaged.emit(hurtbox)
	else:
		enemy_destroyed.emit(hurtbox)