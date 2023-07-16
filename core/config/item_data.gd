extends Node

const ITEM_PATH : String = "res://data/items"
var items := {}

# Tutorial code, PLEASE dont use an array jackass
func _ready():
	var directory = DirAccess.open(ITEM_PATH)
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			var item = load(ITEM_PATH.path_join(filename))
			items[item.name] = item
		filename = directory.get_next()

func get_item(item_name : String):
	if items.has(item_name):
		return items[item_name]
	return null
