class_name Plant extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hitbox.damaged.connect(takeDamage)

func takeDamage(_damage: int) -> void:
	queue_free()
