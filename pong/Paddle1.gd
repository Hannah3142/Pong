extends Area2D

class_name Paddle1

# -10, 10; -15, 15
var start_angle = -15
var end_angle = 15
var paddle_speed = 5

var radius = 250
var point_count = 50
var thickness = 20
var white = Color.WHITE

var paddle_rotation = 0

var collision_poly: CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(575, 323.5)
	generate_collision_polygon()
	queue_redraw()
	paddle_rotation = 90
	rotation = deg_to_rad(paddle_rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_LEFT):
		rotation += deg_to_rad(paddle_speed)
	elif Input.is_key_pressed(KEY_RIGHT):
		rotation -= deg_to_rad(paddle_speed)
	paddle_rotation = rad_to_deg(rotation)
	paddle_rotation = wrapf(paddle_rotation, 0, 360)

func _draw():
	draw_arc(Vector2.ZERO, radius, deg_to_rad(start_angle), deg_to_rad(end_angle), point_count, white, thickness)

func generate_collision_polygon() -> void:
	collision_poly = CollisionPolygon2D.new()
	
	var points = PackedVector2Array()
	var r_start = deg_to_rad(start_angle)
	var r_end = deg_to_rad(end_angle)
	var outer_r = radius - thickness/3
	var inner_r = radius - thickness/2
	
	for i in range(20 + 1):
		var t = float(i) / 20
		var angle = lerp(r_start, r_end, t)
		var pt = Vector2(cos(angle), sin(angle)) * outer_r
		points.append(pt)
	
	for i in range(20, -1, -1):
		var t = float(i) / 20
		var angle = lerp(r_start, r_end, t)
		var pt = Vector2(cos(angle), sin(angle)) * inner_r
		points.append(pt)
	
	collision_poly.polygon = points
	add_child(collision_poly)
