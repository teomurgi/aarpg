class_name StateCarry extends State

@export var move_speed: float = 100.0
@export var throw_audio: AudioStream

var walking: bool = false
var throwable: Throwable

@onready var idle: StateIdle = $"../Idle"
@onready var stun: StateStun = $"../Stun"


func init() -> void:
	pass

## What happens when the player enters this state
func enter() -> void:
	player.update_animation("carry")
	walking = false

## What happens when the player exits this state
func exit() -> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
		if state_machine.next_state == stun:
			throwable.throw_direction = throwable.throw_direction * -1
			throwable.drop()
		else:
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()

## What happens during the _process update in this State
func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.update_animation("carry")
	elif player.set_direction() or walking == false:
		walking = true
		player.update_animation("carry_walk")
	player.velocity = player.direction * move_speed
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> State:
	return null

## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	if Input.is_action_pressed("attack") or Input.is_action_pressed("interact"):
		return idle
	return null
