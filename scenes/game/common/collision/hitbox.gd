class_name Hitbox
extends Node2D

@export var damage : float = 0
@export var knockback : float = 0
@export var angle : float = 0
@export var hitstun : float = 0
@export var hitsound : String = "squeak"

func enable():
	get_node("Area2D/CollisionShape2D").disabled = false

func disable():
	get_node("Area2D/CollisionShape2D").disabled = true

func reset():
	damage = 0
	knockback = 0
	angle = 0
	hitstun = 0
	hitsound = "squeak"
	disable()
