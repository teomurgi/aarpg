class_name StateWalk extends State

@export var move_speed: float = 100.0

@onready var idleState: State = $"../Idle"
@onready var attackState: State = $"../Attack"


## What happens when the player enters this state
func enter() -> void:
	player.update_animation("walk")

## What happens when the player exits this state
func exit() -> void:
	pass

## What happens during the _process update in this State
func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idleState
		
	player.velocity = player.direction * move_speed
	if player.set_direction():
		player.update_animation("walk")
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> State:
	return null

## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attackState
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
