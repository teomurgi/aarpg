class_name EnemyStateWander extends EnemyState


@export var anim_name: String = "walk"
@export var wander_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3
@export var next_state: EnemyState

var _timer: float = 0.0
var _direction: Vector2

func init() -> void:
	pass # Replace with function body.


## What happens when the player enters this state
func enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[rand]
	enemy.velocity = _direction * wander_speed
	enemy.setDirection(_direction)
	enemy.updateAnimation(anim_name)
	
## What happens when the player exits this state
func exit() -> void:
	pass

## What happens during the _process update in this State
func process(delta: float) -> EnemyState:
	_timer -= delta
	if _timer <= 0.0:
		return next_state
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> EnemyState:
	return null
	
