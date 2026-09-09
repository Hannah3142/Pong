extends Area2D

var radius = 10
var angle = 0
const white = Color.WHITE

var target_speed = 7
var ball_speed = 0

signal diverted
signal failed
signal adjustz

var adjust_speed = true

var turn = 1
var player_amount = 1

func _ready() -> void:
	position = Vector2(575, 323.5)
	queue_redraw()
	var collision_node = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	collision_node.shape = circle_shape
	add_child(collision_node)
	area_entered.connect(on_area_entered)

func _process(delta: float) -> void:
	if (position - Vector2(575, 323.5)).length() >= 270 and adjust_speed == true:
		ball_speed = 0.2
		adjust_speed = false
		failed.emit()
	
	if adjust_speed == true and ball_speed < target_speed and ball_speed != 0:
		ball_speed = move_toward(ball_speed, target_speed, delta)

func _physics_process(delta: float) -> void:
	var r_angle = deg_to_rad(angle)
	var velocity = Vector2(cos(r_angle), sin(r_angle))*ball_speed
	position += velocity
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, white, true, -1, true)

func on_area_entered(other_area: Area2D) -> void:
	var divert = false
	if "Paddle"+str(turn) == other_area.name:
		divert = true
	if divert == true:
		var hit_direction = (position - Vector2(575, 323.5)).normalized()
		var velocity_direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
		var reflected_direction = velocity_direction.bounce(hit_direction)
		angle = wrapf(rad_to_deg(reflected_direction.angle()), 0, 360)
		diverted.emit()
		adjustz.emit()
