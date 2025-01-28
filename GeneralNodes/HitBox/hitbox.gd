class_name Hitbox extends Area2D

signal damaged(hurtbox: Hurtbox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func take_damage(hurtbox: Hurtbox) -> void:
	print("Hitbox took damage")
	damaged.emit(hurtbox)
	return
