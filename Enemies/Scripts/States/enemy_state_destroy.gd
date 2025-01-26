class_name EnemyStateDestroy extends EnemyState

@export var anim_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

var _direction: Vector2

func init() -> void:
	enemy.enemy_destroyed.connect(onEnemyDestroyed)


## What happens when the player enters this state
func enter() -> void:
	enemy.invulnerable = true

	_direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.setDirection(_direction)
	enemy.velocity = -_direction * knockback_speed
	enemy.updateAnimation(anim_name)
	
	enemy.animation_player.animation_finished.connect(onAnimationFinished)
	
## What happens when the player exits this state
func exit() -> void:
	pass

## What happens during the _process update in this State
func process(delta: float) -> EnemyState:
	enemy.velocity = enemy.velocity * decelerate_speed * delta
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> EnemyState:
	return null
	

func onEnemyDestroyed() -> void:
	state_machine.changeState(self)

func onAnimationFinished(_name: String) -> void:
	enemy.queue_free()