class_name EnemyStateStun extends EnemyState

@export var anim_name: String = "stun"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")
@export var next_state: EnemyState

var _direction: Vector2
var _animation_finished: bool = false

func init() -> void:
	enemy.enemy_damaged.connect(onEnemyDamaged)


## What happens when the player enters this state
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false

	_direction = enemy.global_position.direction_to(enemy.player.global_position)

	enemy.setDirection(_direction)
	enemy.velocity = -_direction * knockback_speed
	enemy.updateAnimation(anim_name)
	enemy.animation_player.animation_finished.connect(onAnimationFinished)
	
## What happens when the player exits this state
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(onAnimationFinished)

## What happens during the _process update in this State
func process(delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity = enemy.velocity * decelerate_speed * delta
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> EnemyState:
	return null
	

func onEnemyDamaged() -> void:
	state_machine.changeState(self)

func onAnimationFinished(_name: String) -> void:
	_animation_finished = true