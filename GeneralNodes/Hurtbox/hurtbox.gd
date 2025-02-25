class_name Hurtbox extends Area2D

signal did_damage

@export var damage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(enter_area)

func enter_area(a: Area2D) -> void:
	if a is Hitbox:
		did_damage.emit()
		a.take_damage(self)
