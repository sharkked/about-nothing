extends Control

@onready var grid = $MarginContainer/Items/ItemList

func _ready():
	pass
	#Game.data.inventory.changed.connect(self._on_inventory_changed)
	#_on_inventory_changed(Game.data.inventory)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			visible = !visible;

func _on_inventory_changed(inventory):
	for n in grid.get_children():
		n.queue_free()
	
	for item in inventory.get_items():
		var item_label = Label.new()
		item_label.text = "%s x %d" % [item.item_reference.name, item.quantity]
		grid.add_child(item_label)
