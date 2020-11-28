extends CanvasLayer

func _process(delta):
	$RichTextLabel.text = "x " + String(Globals.coin_count)
