extends Node

const PX_PER_METER := 50.0

var jump_force := 550.0
var speed := 200.0
var coin_mult := 1.0
var score_mult := 1.0
var max_jumps := 1
var shield := false

var start_y := 450.0
var height_px := 0.0

func update_height(y: float):
	height_px = max(height_px, start_y - y)

func meters() -> int:
	return int(height_px / PX_PER_METER)

func reset_run():
	height_px = 0.0

func apply(id: String):
	match id:
		"jump": jump_force += 40
		"speed": speed += 30
		"coins": coin_mult += 0.5
		"score": score_mult += 0.5
		"double_jump": max_jumps += 1
		"shield": shield = true
