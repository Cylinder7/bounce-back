extends Area2D

enum Kind { BOOST, INVERT, SLIPPERY }

const DATA = {
	Kind.BOOST: {"name": "boost", "time": 8.0},
	Kind.INVERT: {"name": "invert", "time": 6.0},
	Kind.SLIPPERY: {"name": "slippery", "time": 8.0},
}

@export var kind: Kind = Kind.BOOST
@export var textures: Array[Texture2D]

func _ready():
	if kind < textures.size() and textures[kind]:
		$Sprite2D.texture = textures[kind]
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("add_effect"):
		body.add_effect(DATA[kind]["name"], DATA[kind]["time"])
		queue_free()
