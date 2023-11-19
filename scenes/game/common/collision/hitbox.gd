class_name Hitbox
extends Area2D

signal hit_landed

@export var damage : float = 0
@export var knockback : float = 0
@export var angle : float = 0
@export var hitstun : float = 0
@export var hitsound : String = "squeak"

func _init() -> void:
	collision_layer = 32
	collision_mask = 64
	modulate = Color(255, 0, 0)

func enable():
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = false

func disable():
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true

func reset():
	damage = 0
	knockback = 0
	angle = 0
	hitstun = 0
	hitsound = "squeak"
	disable()

func _on_area_entered(hurtbox: Hitbox) -> void:
	if hurtbox == null or hurtbox.owner == owner:
		return
	
	emit_signal("hit_landed", self, hurtbox)
