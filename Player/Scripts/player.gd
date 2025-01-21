class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	).normalized()
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func setDirection() -> bool:
	var new_cardinal_direction: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false;
		
	if direction.y == 0:
		new_cardinal_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_cardinal_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_cardinal_direction == cardinal_direction:
		return false;
	cardinal_direction = new_cardinal_direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
func updateAnimation(state: String) -> void:
	animation_player.play(state + "_" + animationDirection())

func animationDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	if cardinal_direction == Vector2.UP:
		return "up"
	return "side"
