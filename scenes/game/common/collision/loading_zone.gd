class_name LoadingZone 
extends Area2D 

@export var room_name : String

func _on_loading_zone_body_entered(_body):
	if room_name != "":
		pass
		#Game.room_switch.call_deferred(room_name)
