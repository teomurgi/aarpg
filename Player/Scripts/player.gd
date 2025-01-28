class_name Player extends CharacterBody2D

const DIR_4 = [
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.UP
]

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hitbox: Hitbox = $Hitbox

signal direction_changed(new_direction: Vector2)
signal player_damaged(hurtbox: Hurtbox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player = self
	state_machine.initialize(self)
	hitbox.damaged.connect(take_damage)
	update_hp(99)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	).normalized()
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func set_direction() -> bool:
	
	if direction == Vector2.ZERO:
		return false;
		
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_cardinal_direction: Vector2 = DIR_4[direction_id]
	
	if new_cardinal_direction == cardinal_direction:
		return false;
	cardinal_direction = new_cardinal_direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	direction_changed.emit(cardinal_direction)
	return true
	
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + animation_direction())

func animation_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	if cardinal_direction == Vector2.UP:
		return "up"
	return "side"

func take_damage(hurtbox: Hurtbox) -> void:
	if invulnerable == true:
		return
	update_hp(-hurtbox.damage)
	if hp > 0:
		player_damaged.emit(hurtbox)
	else:
		player_damaged.emit(hurtbox)
		update_hp(99)

func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)

func make_invulnerable(duration: float = 1.0) -> void:
	invulnerable = true
	hitbox.monitoring = false

	await get_tree().create_timer(duration).timeout

	invulnerable = false
	hitbox.monitoring = true
	