class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/PauseMenu/Inventory/inventory_slot.tscn")

@export var data: InventoryData

var focus_index: int = 0


func _ready() -> void:
    PauseMenu.shown.connect(update_inventory)
    PauseMenu.hidden.connect(clear_inventory)
    clear_inventory()
    data.changed.connect(on_inventory_changed)

func clear_inventory() -> void:
    for c in get_children():
        c.queue_free()

func update_inventory(i: int = 0) -> void:
    for s in data.slots:
        var new_slot = INVENTORY_SLOT.instantiate()
        add_child(new_slot)
        new_slot.set_slot_data(s)
        new_slot.focus_entered.connect(item_focused)
    await get_tree().process_frame
    get_child(i).grab_focus()

func item_focused() -> void:
    for c in get_children():
        if c.has_focus():
            focus_index = 1
            return

func on_inventory_changed() -> void:
    clear_inventory()
    update_inventory(focus_index)


