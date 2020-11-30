extends CanvasLayer

func _process(delta):
	$CoinCountLabel.text = "x " + String(Globals.coin_count)
	$TimerLabel.text = Globals.string_timer
