class_name StateStun extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

var hurtbox: Hurtbox
var direction: Vector2
var next_state: State = null

@onready var idleState: State = $"../Idle"
@onready var deathState: State = $"../Death"

func init() -> void:
	player.player_damaged.connect(_player_damaged)

## What happens when the player enters this state
func enter() -> void:

	player.animation_player.animation_finished.connect(on_animation_finished)
	direction = player.global_position.direction_to((hurtbox.global_position))
	player.velocity = -direction * knockback_speed
	player.set_direction()
	player.update_animation("stun")
	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")

	PlayerManager.shake_camera(hurtbox.damage)

## What happens when the player exits this state
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(on_animation_finished)
	pass

## What happens during the _process update in this State
func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	player.set_direction()
	return next_state
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> State:
	return null

## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	return null

func _player_damaged(_hurtbox: Hurtbox) -> void:
	hurtbox = _hurtbox
	if state_machine.current_state != deathState:
		state_machine.change_state(self)
	pass

func on_animation_finished(_name: String) -> void:
	next_state = idleState
	if player.hp <= 0:
		next_state = deathState
