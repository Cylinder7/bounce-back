extends CanvasLayer

func _ready():
	hide()
	$RestartButton.pressed.connect(_on_restart_pressed)

func show_game_over():
	$MetersLabel.text = "Meters Climbed: " + str(Stats.meters()) + " m"
	show()
	$RestartButton.grab_focus()
	get_tree().paused = true

func _on_restart_pressed():
	Stats.reset_run()
	get_tree().paused = false
	get_tree().reload_current_scene()
