class_name Hurtbox
extends Area2D

signal hit_taken

enum HurtboxState {
	NORMAL,
	INTANGIBLE
}

@export var state := HurtboxState.NORMAL

func _init() -> void:
	collision_layer = 64
	collision_mask = 32
	modulate = Color(0, 255, 0)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null or hitbox.owner == owner:
		return
	
	if state == HurtboxState.NORMAL:
		emit_signal("hit_taken", self, hitbox)
