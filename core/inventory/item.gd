class_name ItemResource
extends Resource

@export var name : String
@export var stackable : bool = false
@export var max_stack_size : int = 1

enum ItemType { GENERIC, CONSUMABLE, EQUIPMENT, KEY }
@export_node_path("ItemType") var type
