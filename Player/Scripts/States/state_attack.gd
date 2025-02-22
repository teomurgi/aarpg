class_name StateAttack extends State

var isAttacking: bool = false

@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var decellerate_speed: float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var walkState: State = $"../Walk"
@onready var idleState: StateIdle = $"../Idle"
@onready var chargeAttackState: StateChargeAttack = $"../ChargeAttack"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurtbox: Hurtbox = %AttackHurtbox


## What happens when the player enters this state
func enter() -> void:
	attack_anim_player.play("attack_" + player.animation_direction())
	player.update_animation("attack")
	animation_player.animation_finished.connect(end_attack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	isAttacking = true
	await get_tree().create_timer(0.075).timeout
	if isAttacking:
		hurtbox.monitoring = true
	

## What happens when the player exits this state
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	isAttacking = false
	hurtbox.monitoring = false

## What happens during the _process update in this State
func process(_delta: float) -> State:
	player.velocity -= player.velocity * decellerate_speed * _delta 
	
	if !isAttacking:
		if player.direction == Vector2.ZERO:
			return idleState
		return walkState
	return null
	
## What happens during the _physics_process update in this State
func physics(_delta: float) -> State:
	return null

## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	return null

func end_attack(_newAnimName: String) -> void:
	if Input.is_action_pressed("attack"):
		state_machine.change_state(chargeAttackState)
	isAttacking = false
