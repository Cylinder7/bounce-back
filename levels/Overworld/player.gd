extends CharacterBody2D

const GRAVITY = 1200.0
const SCREEN_WIDTH = 360.0

var grip := 1.0

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	var target = Input.get_axis("ui_left", "ui_right") * Stats.speed
	velocity.x = lerpf(velocity.x, target, grip)

	move_and_slide()

	if is_on_floor():
		grip = 1.0
		var jump = Stats.jump_force
		var col = get_last_slide_collision()
		if col:
			var other = col.get_collider()
			if other and other.has_method("on_land"):
				jump = other.on_land(self, jump)
		velocity.y = -jump

	position.x = wrapf(position.x, 0, SCREEN_WIDTH)
	Stats.update_height(position.y)
