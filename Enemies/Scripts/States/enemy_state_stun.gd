class_name EnemyStateStun extends EnemyState

@export var anim_name: String = "stun"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")
@export var next_state: EnemyState

var _damage_position: Vector2
var _direction: Vector2
var _animation_finished: bool = false

func init() -> void:
	enemy.enemy_damaged.connect(on_enemy_damaged)


## What happens when the player enters this state
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false

	_direction = enemy.global_position.direction_to(_damage_position)

	enemy.set_direction(_direction)
	enemy.velocity = -_direction * knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(on_animation_finished)
	
## What happens when the player exits this state
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(on_animation_finished)

## What happens during the _process update in this State
func process(delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity = enemy.velocity * decelerate_speed * delta
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> EnemyState:
	return null
	

func on_enemy_damaged(hurtbox: Hurtbox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.change_state(self)

func on_animation_finished(_name: String) -> void:
	_animation_finished = true