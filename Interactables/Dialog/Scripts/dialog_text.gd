@tool
@icon("res://GUI/DialogSystem/Icons/text_bubble.svg")
class_name DialogText extends DialogItem

@export_multiline var text: String = "Placeholder": set = _set_text

func _set_editor_display() -> void:
    example_dialog.set_dialog_text(self)
    example_dialog.content.visible_characters = -1

func _set_text(value: String) -> void:
    text = value
    if Engine.is_editor_hint():
        if example_dialog != null:
            _set_editor_display()