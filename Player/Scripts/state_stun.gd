class_name StateStun extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

var hurtbox: Hurtbox
var direction: Vector2
var next_state: State = null

@onready var idleState: State = $"../Idle"

func init() -> void:
	player.player_damaged.connect(_player_damaged)

## What happens when the player enters this state
func enter() -> void:

	player.animation_player.animation_finished.connect(onAnimationFinished)
	direction = player.global_position.direction_to((hurtbox.global_position))
	player.velocity = -direction * knockback_speed
	player.setDirection()
	player.updateAnimation("stun")
	player.makeInvulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")

## What happens when the player exits this state
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(onAnimationFinished)
	pass

## What happens during the _process update in this State
func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	player.setDirection()
	return next_state
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> State:
	return null

## What happens with input events in this State
func handleInput(_event: InputEvent) -> State:
	return null

func _player_damaged(_hurtbox: Hurtbox) -> void:
	hurtbox = _hurtbox
	state_machine.changeState(self)
	pass

func onAnimationFinished(_name: String) -> void:
	next_state = idleState
	pass
