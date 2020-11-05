extends Camera2D

export (NodePath) var target_path

var shake_length: int = 0 # How quickly the shaking stops [0, 1].

var zoom_shake: float = 0  #how much the camera shakes at the begining of the shake
var zoom_shake_remaining: float = 0  #how much it shakes now

var target_zoom: Vector2 = Vector2(1, 1)
var zoom_speed: float = 0.025

var offset_shake: float = 0  #how much the camera shakes at the begining of the shake
var offset_shake_remaining: float = 0  #how much it shakes now

func _ready() -> void:
	randomize()
	
	shake(10, 10)

func _process(delta : float) -> void:
	position = get_node(target_path).position
	
	if offset_shake_remaining > 0:
		offset = Vector2(rand_range(offset_shake_remaining, -offset_shake_remaining), rand_range(offset_shake_remaining, -offset_shake_remaining))
		offset_shake_remaining = max(0, move_toward(offset_shake_remaining, 0, shake_length / offset_shake))
	
	zoom.x = move_toward(zoom.x, target_zoom.x, zoom_speed)
	zoom.x = move_toward(zoom.y, target_zoom.y, zoom_speed)

func shake(frames: float, offset_magnitude: float = 0, zoom_magnitude: float = 0) -> void:
	offset_shake = offset_magnitude
	offset_shake_remaining = offset_magnitude
	
	zoom_shake = zoom_magnitude
	zoom_shake_remaining = zoom_magnitude
	
	shake_length = frames

func ease_zoom(new_value: Vector2, new_zoom_speed: float = 0.025) -> void:
	target_zoom = new_value
	
	zoom_speed = new_zoom_speed
