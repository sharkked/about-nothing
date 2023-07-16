extends TileMap

var lock_tiles = Array()

func _ready():
	pass
	#Game.connect("player_initialized", self, "_on_player_initialized")

	#lock_tiles = get_used_cells_by_id(6)

func _on_player_initialized(_player):
	Game.data.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")

func _on_player_inventory_changed(inventory):
	for item in inventory.get_items():
		if item.item_reference.name == "Key":
			for tile in lock_tiles:
				set_cell(tile.x, tile.y, -1)
			return

