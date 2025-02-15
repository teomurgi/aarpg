@tool
@icon("res://GUI/DialogSystem/Icons/answer_bubble.svg")
class_name DialogBranch extends Node

@export var text: String = "ok..."

var dialog_items: Array[DialogItem]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for c in get_children():
		if c is DialogItem:
			dialog_items.append(c)