extends CanvasLayer

var hearts: Array[HearthGUI] = []
@onready var h_flow_container: HFlowContainer = $Control/HFlowContainer

func _ready() -> void:
	for child in h_flow_container.get_children():
		if child is HearthGUI:
			hearts.append(child)
			child.visible = false


func updateHp(_hp: int, _max_hp: int) -> void:
	updateMaxHp(_max_hp)
	for i in _max_hp:
		updateHeart(i, _hp)

func updateHeart(_index: int, _hp: int) -> void:
	var _value: int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value

func updateMaxHp(_max_hp: int) -> void:
	var _heart_count: int = roundi(_max_hp * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
