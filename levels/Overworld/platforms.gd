extends Node2D

@export var platform_scene: PackedScene
@export var camera: Camera2D
@export var pickup_scene: PackedScene
const PICKUP_CHANCE := 0.15

var next_y := 400.0
var count := 0

func _process(_delta):
	while next_y > camera.position.y - 400.0:
		spawn()
	for p in get_children():
		if p.position.y > camera.position.y + 400.0:
			p.queue_free()

func spawn():
	var type = Platform.Type.NORMAL if count < 5 else pick_type()
	var p = platform_scene.instantiate()
	p.position = Vector2(randf_range(60.0, 300.0), next_y)
	p.type = type
	add_child(p)
	if type != Platform.Type.BREAKABLE and count >= 5 and randf() < PICKUP_CHANCE:
		var pk = pickup_scene.instantiate()
		pk.kind = randi() % 3
		pk.position = Vector2(0, -18)
		p.add_child(pk)

	# The gap above a platform depends on how high that platform bounces you
	var base = (Stats.jump_force * Stats.jump_force) / (2.0 * 1200.0) * 0.8
	var mult = Platform.JUMP_MULT[type]
	var max_gap = base * mult * mult
	next_y -= randf_range(max_gap * 0.5, max_gap)
	count += 1

func pick_type() -> int:
	var m = Stats.meters()
	var weights = {
		Platform.Type.NORMAL: 100.0,
		Platform.Type.MOVING: clampf(m * 0.5, 0.0, 30.0),
		Platform.Type.BREAKABLE: clampf(m * 0.3, 0.0, 25.0),
		Platform.Type.SLIPPERY: 0.0 if m < 30 else 15.0,
		Platform.Type.STICKY: 0.0 if m < 60 else 10.0,
	}
	var total = 0.0
	for w in weights.values():
		total += w
	var roll = randf() * total
	for type in weights:
		roll -= weights[type]
		if roll <= 0.0:
			return type
	return Platform.Type.NORMAL
