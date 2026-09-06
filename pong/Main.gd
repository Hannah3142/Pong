extends Node2D

# canvas dimensions: 648, 1152
# center Vector2(575, 323.5)

@onready var ball: Area2D = $Ball
@onready var paddle: Area2D = $Paddle

var score = 0
var high_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/Restart.hide()
	$HUD/Restart.pressed.connect(new_game)
	ball.failed.connect(failed)
	ball.diverted.connect(increase_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ball.ball_speed == 0:
		ball.position = Vector2(575+225*cos(paddle.rotation), 323.5+225*sin(paddle.rotation))
		if Input.is_action_pressed("ui_up"):
			ball.ball_speed = 3
			if ball.position.x < 575:
				if ball.position.y < 323.5:
					ball.angle = randi_range(10, 80)
				else:
					ball.angle = randi_range(280, 350)
			else:
				if ball.position.y < 323.5:
					ball.angle = randi_range(100, 170)
				else:
					ball.angle = randi_range(190, 260)

func failed():
	$HUD/Restart.show()
	if score > high_score:
		high_score = score
	$HUD/HighScore.text = str(high_score) + "HIGH SCORE"

func new_game():
	$HUD/Restart.hide()
	
	var ball_x = 575+225*cos(paddle.rotation)
	var ball_y = 323.5+225*sin(paddle.rotation)
	ball.position = Vector2(ball_x, ball_y)
	ball.ball_speed = 0
	#ball.angle = randi_range(0, 359)
	ball.is_game_over = false
	ball.adjust_speed = true
	score = 0
	$HUD/Score.text = str(score) + " Score"

func increase_score():
	score += 1
	$HUD/Score.text = str(score) + " Score"
