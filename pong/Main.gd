extends Node2D

# canvas dimensions: 648, 1152

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_viewport_rect().end.y)
	print(get_viewport_rect().end.x)
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	const grey = Color(0.35, 0.35, 0.35, 1)
	draw_circle(Vector2(500, 350), 250, grey, false, 20.0)
	draw_arc(Vector2(500, 350), 250, deg_to_rad(75), deg_to_rad(105), 50, Color.WHITE, 20)
