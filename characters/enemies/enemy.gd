class_name Enemy
extends Character

@onready var hitparticles := $HitParticles

func _ready():
	super._ready()

func ready():
	gravity = FALL_GRV
	
func damage(hitbox: Hitbox):
	var a = deg_to_rad(hitbox.angle)
	snap = Vector2.ZERO
	
	velocity = hitbox.knockback * 3 * Vector2(hitbox.owner.direction.x * cos(a), -sin(a))
	direction = Vector2.RIGHT * sign(global_position.x - hitbox.global_position.x)
	hitbox.owner.velocity -= velocity
	hitstun = hitbox.hitstun
	hitstop = floor(hitbox.damage / 3 + 3) * 0.017
	
	SoundManager.play_se(hitbox.hitsound)
	
	$HitParticles.direction = -velocity
	$HitParticles.amount = hitbox.knockback / 5
	$HitParticles.initial_velocity_min = 90 + hitbox.knockback
	$HitParticles.emitting = true
	$HitParticles.global_position.y = hitbox.global_position.y

func process(_delta):
	var drift = 0.2
	
	if hitstun > 0:
		drift = 0.02
		gravity = FALL_GRV * 0.02
	else:
		drift = 0.2 if is_on_floor() else 0.1
		gravity = FALL_GRV
		snap = DEFAULT_SNAP
	
	if hitstop <= 0:
		velocity.x = lerp(velocity.x, 0.0, drift)
		$HitParticles.emitting = false
	
	
	flip_h(direction.x)
