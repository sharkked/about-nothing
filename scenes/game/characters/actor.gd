class_name Actor
extends CharacterBody2D

# public
@onready var animation = $AnimationPlayer
@onready var sprite = $Pivot/Sprite

@onready var hitboxes = $Pivot/Hitboxes.get_children()

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

var hitstop : float = 0
var hitstun : float = 0

func _ready():
	ready()

func ready():
	pass

func _process(delta):
	process(delta)
	
	if hitstop > 0:
		hitstop = max(0, hitstop - delta)
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

func _on_Hurtbox_area_entered(area):
	if not area.owner.owner == self:
		if area.owner is Hitbox:
			var hb = area.owner as Hitbox
			damage(hb)
			hb.owner.hitstop = floor(hb.damage / 3 + 3) * 0.017
			if hb.owner.name == "Player":
				hb.owner.jump_cancel = true

func damage(_hitbox: Hitbox):
	pass

func play_se(sound : String) -> void:
	SoundManager.play_se(sound)
