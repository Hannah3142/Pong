extends Area2D

class_name Paddle # needed?

@export var paddle_name: String
@export var paddle_colour: Color
@export var controls: String
@export var initial_rotation: float

var start_angle = -20
var end_angle = 20
var paddle_speed = 5

var radius = 250
var point_count = 50
var thickness = 20

var collision_poly: CollisionPolygon2D

var acceleration = 0.0
var current_speed = 0
var left_key = KEY_LEFT
var right_key = KEY_RIGHT

func _ready() -> void:
	position = Vector2(575, 323.5)
	generate_collision_polygon()
	queue_redraw()

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(left_key):
		acceleration = move_toward(current_speed, paddle_speed, 50*delta)
		rotation += deg_to_rad(acceleration)
		current_speed = acceleration
	elif Input.is_key_pressed(right_key):
		acceleration = move_toward(current_speed, paddle_speed, 50*delta)
		rotation -= deg_to_rad(acceleration)
		current_speed = acceleration
	else:
		acceleration = 0
		current_speed = 0

func _draw():
	draw_arc(Vector2.ZERO, radius, deg_to_rad(start_angle), deg_to_rad(end_angle), point_count, paddle_colour, thickness)

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

func setup(p_name: String, p_color: Color, p_control: String, p_rotation: float) -> void:
	paddle_name = p_name
	paddle_colour = p_color
	controls = p_control
	initial_rotation = p_rotation
	rotation = deg_to_rad(initial_rotation)
	name = paddle_name
	
	if controls != "arrows":
		left_key = OS.find_keycode_from_string(controls[0])
		right_key = OS.find_keycode_from_string(controls[1])
