class_name LoadingZone 
extends Area2D 

@export var room_name : String

func _on_loading_zone_body_entered(body):
	if room_name != "":
		if body == Game.player:
			Game.room_switch.call_deferred(room_name)
