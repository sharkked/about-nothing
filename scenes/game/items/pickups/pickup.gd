class_name Pickup
extends Area2D

var is_collected : bool = false

@export var item := "none"
@export var sound := "thing"

func pickup():
	#Game.data.inventory.add_item(item, 1)
	SoundManager.play_se(sound)
	visible = false	

func _on_pickup_body_entered(_body):
	if not is_collected:
		is_collected = true
		pickup()
		
