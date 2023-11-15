class_name Baseball
extends Bullet

var term_v = 500

func _ready():
	gravity = 500

func start(pos, vel):
	position = pos
	velocity = vel
	rotation = 2 * PI * randf()

func physics_process(delta):
	velocity.y = min(velocity.y + gravity * delta, term_v)
	if is_on_floor():
		velocity.y = - 0.5 * velocity.y
	
	rotation += velocity.x * 0.014
	
	var coll = move_and_collide(velocity * delta)
	if coll:
		velocity = velocity.bounce(coll.get_normal()) * 0.4

func _on_Hitbox_area_entered(area):
	if not area.owner.owner == self:
		if area.owner is Hitbox:
			var hb = area.owner as Hitbox
			hb.owner.hitstop = floor(hb.damage / 3 + 3) * 0.017
			if hb.owner.name == "Player":
				hb.owner.jump_cancel = true
			var a = deg_to_rad(hb.angle)
			velocity = 1.75 * hb.knockback * Vector2(hb.owner.direction.x * cos(a), -sin(a))
