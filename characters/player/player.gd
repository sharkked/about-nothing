class_name Player
extends Character

const air_jump_fx_resource = preload("res://fx/fx_airjump.tscn")
const baseball_resource = preload("res://collision/bullets/baseball.tscn")

@onready var baseball_spawn := $Pivot/BulletSpawn

var camera : VirtualCam2D

# --- movement ---
const AIR_SPD : float = 1720.32
const RUN_SPD : float = 384.0

const FAST_FALL_TIME : float = 0.2

const AIR_DASH_DIST : float = 96.0
const AIR_DASH_TIME : float = 0.2
const AIR_DASH_DECAY : float = 0.1

const AIR_DASH_SPD : float = AIR_DASH_DIST / AIR_DASH_TIME

# --- state ---
var _air_dash_count : int = 0
var _air_jump_count : int = 0

@export var exit_state : bool = false
@export var cancel_state : bool = false
@export var jump_cancel : bool = false

func _ready():
	super._ready()

func ready():
	gravity = FALL_GRV
	reset_hitboxes()
	
func reset_on_land():
	gravity = FALL_GRV
	_air_dash_count = 0
	_air_jump_count = 0

func ball_toss():
	_spawn_ball(baseball_spawn.global_position - global_position, Vector2(0.25 * velocity.x, -170))

func _spawn_ball(offset, vel):
	var proj = baseball_resource.instantiate() as Baseball
	proj.start(global_position + offset, vel)
	get_parent().add_child(proj)
	SoundManager.play_se("shoot")

func reset_hitboxes():
	for hb in hitboxes:
		hb.position = Vector2.ZERO
		hb.scale = Vector2.ZERO
		hb.damage = 0
		hb.knockback = 0
		hb.angle = 0
		hb.hitstun = 0
		hb.hitsound = "squeak"
		hb.get_node("Area2D/CollisionShape2D").disabled = true
