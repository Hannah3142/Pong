extends Area2D

var radius = 10
const white = Color.WHITE
var angle = 0

var target_speed = 7
var ball_speed = 0

signal diverted
signal failed
var is_game_over = true
var adjust_speed = true

var turn = 1
var player_amount = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(575, 323.5)
	queue_redraw()
	var collision_node = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	collision_node.shape = circle_shape
	add_child(collision_node)
	area_entered.connect(on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (sqrt(pow(position.x-575, 2) + pow(position.y-323.5, 2))) >= 270: #and is_game_over == false
		ball_speed = 0.2
		adjust_speed = false
		if is_game_over == false:
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
	if turn == 1 and (other_area is Paddle1):
		divert = true
	if turn == 2 and (other_area is Paddle2):
		divert = true
	if divert == true:
		var hit_direction = (position - Vector2(575, 323.5)).normalized()
		var hit_angle = wrapf(rad_to_deg(hit_direction.angle()), 0, 360)
		
		var alpha = abs(hit_angle-angle)
		if angle < hit_angle:
			angle = angle + 2*alpha -180
		else:
			angle = angle - 2*alpha -180
		angle = wrapf(angle, 0, 360)
		if player_amount > 1:
			if turn == 1:
				turn = 2
			else:
				turn = 1
		diverted.emit()
