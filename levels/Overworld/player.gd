extends CharacterBody2D

const GRAVITY = 1200.0
const SCREEN_WIDTH = 360.0
const BOOST_MULT = 1.4
const SLIP_GRIP = 0.03

var grip := 1.0
var effects := {}

func add_effect(effect_name: String, duration: float):
	effects[effect_name] = duration

func _physics_process(delta):
	for k in effects.keys():
		effects[k] -= delta
		if effects[k] <= 0.0:
			effects.erase(k)

	velocity.y += GRAVITY * delta

	var dir = Input.get_axis("ui_left", "ui_right")
	if effects.has("invert"):
		dir = -dir

	var g = grip
	if effects.has("slippery"):
		g = min(g, SLIP_GRIP)
	velocity.x = lerpf(velocity.x, dir * Stats.speed, g)

	move_and_slide()

	if is_on_floor():
		grip = 1.0
		var jump = Stats.jump_force
		if effects.has("boost"):
			jump *= BOOST_MULT
		var col = get_last_slide_collision()
		if col:
			var other = col.get_collider()
			if other and other.has_method("on_land"):
				jump = other.on_land(self, jump)
		velocity.y = -jump

	position.x = wrapf(position.x, 0, SCREEN_WIDTH)
	Stats.update_height(position.y)
