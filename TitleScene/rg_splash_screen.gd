extends Control

signal finished

func _ready() -> void:
    $Control/AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void: 
    finished.emit()