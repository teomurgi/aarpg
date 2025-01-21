class_name Hitbox extends Area2D

signal damaged(damage: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func takeDamage(damage: int) -> void:
	print("Damage taken: ", damage)
	damaged.emit(damage)
	return
