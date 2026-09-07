extends Node2D

# canvas dimensions: 648, 1152
# center Vector2(575, 323.5)

@onready var ball: Area2D = $Ball
@onready var paddle1: Area2D = $Paddle1
@onready var paddle2: Area2D = $Paddle2

var score = 0
var high_score = 0
var start_player = 1

var player1_mistakes = 0
var player2_mistakes = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/Restart.hide()
	$HUD/Winner.hide()
	$HUD/Restart.pressed.connect(restart)
	ball.failed.connect(failed)
	ball.diverted.connect(increase_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ball.ball_speed == 0:
		var paddle_rotation = 0
		if start_player == 1:
			paddle_rotation = paddle1.rotation
		else:
			paddle_rotation = paddle2.rotation
		ball.position = Vector2(575+215*cos(paddle_rotation), 323.5+215*sin(paddle_rotation))
		if (start_player == 1 and Input.is_key_pressed(KEY_UP)) or (start_player == 2 and Input.is_key_pressed(KEY_W)):
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
			if start_player == 1:
				start_player = 2
			else:
				start_player = 1

func failed():
	if ball.turn == 1:
		player1_mistakes += 1
		$HUD/Player1Mistakes.text = "Player 1 Mistakes: " + str(player1_mistakes)
	else:
		player2_mistakes += 1
		$HUD/Player2Mistakes.text = "Player 2 Mistakes: " + str(player2_mistakes)
	if score > high_score:
		high_score = score
	$HUD/HighScore.text = str(high_score) + " HIGH SCORE"
	if player1_mistakes == 5:
		$HUD/Winner.text = "Player 2 WON!!!"
		$HUD/Restart.show()
		$HUD/Winner.show()
		ball.is_game_over = true
		ball.ball_speed == 0
	elif player2_mistakes == 5:
		$HUD/Winner.text = "Player 1 WON!!!"
		$HUD/Winner.show()
		$HUD/Restart.show()
		ball.is_game_over = true
		ball.ball_speed == 0
	elif ball.is_game_over == false:
		new_game()

func new_game():
	$HUD/Restart.hide()
	ball.position = Vector2(575, 323.5)
	ball.adjust_speed = true
	score = 0
	ball.ball_speed = 0
	$HUD/Score.text = str(score) + " Score"

func increase_score():
	score += 1
	$HUD/Score.text = str(score) + " Score"
	$HUD/Turn.text = "Player Turn: " + str(ball.turn)

func restart():
	ball.turn = 1
	start_player = 1
	player1_mistakes = -1
	player2_mistakes = 0
	ball.is_game_over = false
	ball.adjust_speed = true
	$HUD/Winner.hide()
	$HUD/Restart.hide()
	$HUD/Player1Mistakes.text = "Player 1 Mistakes: " + str(player1_mistakes)
	$HUD/Player2Mistakes.text = "Player 2 Mistakes: " + str(player2_mistakes)
	$HUD/Turn.text = "Player Turn: " + str(ball.turn)
	$HUD/Score.text = "0 Score"
