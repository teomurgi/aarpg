@tool
@icon("res://GUI/DialogSystem/Icons/question_bubble.svg")
class_name DialogChoice extends DialogItem

var dialog_branches: Array[DialogBranch]

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    for c in get_children():
        if c is DialogBranch:
            dialog_branches.append(c)
            
func _get_configuration_warnings() -> PackedStringArray:
    if not _check_for_dialog_branches():
        return ["Requires at least two DialogBranch children."]
    else:
        return []


func _check_for_dialog_branches() -> bool:
    var count:int = 0
    for c in get_children():
        if c is DialogBranch:
           count += 1
           if count == 2:
               return true
    return false