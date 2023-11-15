class_name Bullet
extends CharacterBody2D

@export var damage : float = 0
@export var knockback : float = 0
@export var angle : float = 0
@export var hitstun : float = 0
@export var hitstop : float = 0

var direction := Vector2.RIGHT
var gravity : float = 0

var speed : float  = 250

var lifetime : float = 0
var duration : float = 2

func start(pos, dir):
	position = pos
	velocity = Vector2(speed, 0) * dir

func _physics_process(delta):
	if lifetime >= duration:
		queue_free()
	
	lifetime += delta
	
	physics_process(delta)

# virtual function for custom bullet movement
func physics_process(_delta):
	move_and_slide()

# virtual function for on-hit effects
func on_hit(_body):
	pass

# virtual function for end of life effects
func die():
	pass

