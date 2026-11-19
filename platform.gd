class_name Platform
extends StaticBody2D

enum Type { NORMAL, MOVING, SLIPPERY, BREAKABLE, STICKY }

# Multiplies the player's bounce. Used by the spawner to keep gaps reachable.
const JUMP_MULT = {
	Type.NORMAL: 1.0,
	Type.MOVING: 1.0,
	Type.SLIPPERY: 1.0,
	Type.BREAKABLE: 1.0,
	Type.STICKY: 0.7,
}

# Placeholder colors until we have art
const COLORS = {
	Type.NORMAL: Color.WHITE,
	Type.MOVING: Color(0.4, 0.7, 1.0),
	Type.SLIPPERY: Color(0.6, 1.0, 1.0),
	Type.BREAKABLE: Color(1.0, 0.6, 0.3),
	Type.STICKY: Color(0.7, 0.4, 1.0),
}

@export var type: Type = Type.NORMAL

var start_x := 0.0
var t := 0.0

func _ready():
	start_x = position.x
	t = randf() * TAU
	modulate = COLORS[type]

func _physics_process(delta):
	if type == Type.MOVING:
		t += delta
		position.x = start_x + sin(t * 2.0) * 70.0

# Called by the player when it lands. Returns the jump force to use.
func on_land(player, jump: float) -> float:
	match type:
		Type.SLIPPERY:
			player.grip = 0.03
		Type.STICKY:
			jump *= JUMP_MULT[Type.STICKY]
		Type.BREAKABLE:
			$CollisionShape2D.set_deferred("disabled", true)
			var tw = create_tween()
			tw.tween_property(self, "modulate:a", 0.0, 0.2)
			tw.tween_callback(queue_free)
	return jump
