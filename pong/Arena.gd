extends Node2D

# canvas dimensions: 648, 1152
const grey = Color(0.35, 0.35, 0.35, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	draw_circle(Vector2(575, 323.5), 250, grey, false, 20.0)
