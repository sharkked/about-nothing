class_name Actor
extends CharacterBody2D

# public
@onready var animation = $AnimationPlayer
@onready var sprite = $Pivot/Sprite

@onready var hitboxes = $Pivot/Hitboxes.get_children()
@onready var hurtboxes = $Pivot/Hurtboxes.get_children()

var sprite_pos : Vector2

@export var gravity_scale : float = 1

# --- physics ---
# constants
const JUMP_HEIGHT : float = 72.0
const JUMP_TIME : float = 0.3
const FALL_TIME : float = 0.4
const DEFAULT_SNAP := Vector2(0, 5)

# derived constants
const JUMP_SPD : float = -2 * JUMP_HEIGHT / JUMP_TIME
const JUMP_GRV : float = -JUMP_SPD / JUMP_TIME
const FALL_GRV : float = 2 * JUMP_HEIGHT / pow(FALL_TIME, 2)
const TERM_VEL : float = 4 * JUMP_HEIGHT / FALL_TIME

# parameters
var direction := Vector2.RIGHT
var snap := DEFAULT_SNAP
var stop_on_slope : bool = true
var gravity : float = 0

var hitlag : float = 0
var hitstun : float = 0

func _ready():
	for hb in hurtboxes:
		(hb as Hurtbox).hit_taken.connect(_on_hurtbox_hit_taken)
	ready()

func ready():
	pass

func _process(delta):
	process(delta)
	
	if hitlag > 0:
		hitlag = max(0, hitlag - delta)
		animation.speed_scale = 0
		if hitstun > 0:
			sprite.offset = 0.001 * velocity.length() * Vector2(sin(360*randf()), cos(360*randf()))
	else:
		hitstun = max(0, hitstun - delta)
		animation.speed_scale = 1
		sprite.offset = Vector2.ZERO
		
		velocity.y += gravity * delta * gravity_scale
		move_and_slide()
		flip_h(direction.x)

func process(_delta):
	pass

func flip_h(dir):
	if dir < 0:
		$Pivot.scale.x = $Pivot.scale.y * -1
	elif dir > 0:
		$Pivot.scale.x = $Pivot.scale.y * 1

func _on_hitbox_hit_landed(hitbox, _hurtbox):
	hitlag = floor(hitbox.damage / 3 + 3) * 0.017
	if self is Player:
		self.jump_cancel = true

func _on_hurtbox_hit_taken(_hurtbox, hitbox):
	hitlag = floor(hitbox.damage / 3 + 3) * 0.017
	take_damage(hitbox)

func take_damage(_hitbox: Hitbox):
	pass

func play_se(sound : String) -> void:
	SoundManager.play_se(sound)
