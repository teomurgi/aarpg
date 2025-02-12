@tool
@icon("res://GUI/DialogSystem/Icons/chat_bubbles.svg")
class_name DialogInteraction extends Area2D

signal player_interacted
signal finished

@export var enabled: bool = true

var dialog_items: Array[DialogItem]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	for c in get_children():
		if c is DialogItem:
			dialog_items.append(c)

func _on_player_interacted() -> void:
	player_interacted.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	DialogSystem.show_dialog(dialog_items)
	DialogSystem.finished.connect(_on_dialog_finished)
	

func _on_area_entered(_area: Area2D) -> void:
	
	if enabled == false or dialog_items.size() == 0:
		return
	print("Area entered")
	animation_player.play("show")
	PlayerManager.interact_pressed.connect(_on_player_interacted)

func _on_area_exited(_area: Area2D) -> void:
	animation_player.play("hide")
	PlayerManager.interact_pressed.disconnect(_on_player_interacted)

func _on_dialog_finished() -> void:
	DialogSystem.finished.disconnect(_on_dialog_finished)
	finished.emit()

func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_items() == false:
		return ["Requires at least one DialogItem child."]
	else:
		return []

func _check_for_dialog_items() -> bool:
	for c in get_children():
		if c is DialogItem:
			return true
	return false
