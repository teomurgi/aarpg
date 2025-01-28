class_name Plant extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hitbox.damaged.connect(take_damage)

func take_damage(_hurtbox: Hurtbox) -> void:
	print("Plant took damage")
	queue_free()
