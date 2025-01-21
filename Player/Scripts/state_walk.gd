class_name StateWalk extends State

@export var move_speed: float = 100.0

@onready var idleState: State = $"../Idle"
@onready var attackState: State = $"../Attack"


## What happens when the player enters this state
func enter() -> void:
	player.updateAnimation("walk")

## What happens when the player exits this state
func exit() -> void:
	pass

## What happens during the _process update in this State
func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idleState
		
	player.velocity = player.direction * move_speed
	if player.setDirection():
		player.updateAnimation("walk")
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> State:
	return null

## What happens with input events in this State
func handleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attackState
	return null
