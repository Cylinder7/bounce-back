extends Area2D

enum Kind { BOOST, INVERT, SLIPPERY }

const DATA = {
	Kind.BOOST: {"name": "boost", "time": 8.0, "color": Color(0.3, 1.0, 0.4)},
	Kind.INVERT: {"name": "invert", "time": 6.0, "color": Color(1.0, 0.3, 0.8)},
	Kind.SLIPPERY: {"name": "slippery", "time": 8.0, "color": Color(0.4, 0.9, 1.0)},
}

@export var kind: Kind = Kind.BOOST

func _ready():
	modulate = DATA[kind]["color"]
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("add_effect"):
		body.add_effect(DATA[kind]["name"], DATA[kind]["time"])
		queue_free()
