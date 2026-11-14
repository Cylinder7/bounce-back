extends Camera2D

@export var player: Node2D
@export var game_over_screen: CanvasLayer

var dead := false

func _process(_delta):
	if dead:
		return
	if player.position.y < position.y:
		position.y = player.position.y
	if player.position.y > position.y + 340.0:
		dead = true
		game_over_screen.show_game_over()
