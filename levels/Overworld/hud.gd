extends CanvasLayer

@export var player: Node2D

func _process(_delta):
	$AltitudeLabel.text = str(Stats.meters()) + " m"
	var lines: Array[String] = []
	for k in player.effects:
		lines.append("%s %.0fs" % [k.to_upper(), player.effects[k]])
	$EffectsLabel.text = "\n".join(lines)
