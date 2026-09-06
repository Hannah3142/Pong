extends Area2D

var radius = 10
const white = Color.WHITE

var ball_speed = 4
var angle = 75 #randi_range(min, max)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(575, 573)
	queue_redraw()
	var collision_node = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	collision_node.shape = circle_shape
	add_child(collision_node)
	area_entered.connect(on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var r_angle = deg_to_rad(angle)
	var velocity = Vector2(cos(r_angle), sin(r_angle))*ball_speed
	position += velocity
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, white, true, -1, true)

func on_area_entered(other_area: Area2D) -> void:
	angle = wrapf(180 + angle, 0, 360)
