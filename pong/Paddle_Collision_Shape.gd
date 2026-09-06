extends CollisionShape2D

var start_angle = 75
var end_angle = 105
var paddle_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		start_angle += paddle_speed
		end_angle += paddle_speed
		queue_redraw()
	elif Input.is_action_pressed("ui_right"):
		start_angle -= paddle_speed
		end_angle -= paddle_speed
		queue_redraw()

func _draw():
	draw_arc(Vector2(575, 323.5), 250, deg_to_rad(start_angle), deg_to_rad(end_angle), 50, Color.WHITE, 20)
