class_name StateLift extends State

@export var lift_audio: AudioStream

@onready var carry: State = $"../Carry"


## What happens when the player enters this state
func enter() -> void:
	player.update_animation("lift")
	player.animation_player.animation_finished.connect(state_complete)
	player.audio.stream = lift_audio
	player.audio.play()

## What happens when the player exits this state
func exit() -> void:
	pass

## What happens during the _process update in this State
func process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> State:
	return null

## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	return null

func state_complete(_a: String) -> void:
	player.animation_player.animation_finished.disconnect(state_complete)
	state_machine.change_state(carry)
