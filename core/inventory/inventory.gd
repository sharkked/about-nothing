class_name Inventory
extends Resource

@export var _items := Array()

func set_items(new_items):
	_items = new_items
	changed.emit(self)

func get_items():
	return _items

func get_item(index: int):
	return _items[index]

func add_item(item_name: String, quantity: int):
	if quantity <= 0:
		print("nonneg pls")
		return
	
	var item = ItemData.get_item(item_name)
	if not item:
		print("item %s not found lol" % item_name)
		return
	
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	if item.stackable:
		for inventory_item in _items:
			if remaining_quantity == 0:
				break
			
			if not inventory_item.item_reference.name == item.name:
				continue
			
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
	
	while remaining_quantity > 0:
		var new_item = {
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}
		_items.append(new_item)
		remaining_quantity -= new_item.quantity
	
	changed.emit(self)
