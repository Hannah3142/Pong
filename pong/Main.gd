extends Node2D

# canvas dimensions: 648, 1152
# center Vector2(575, 323.5)

@onready var ball: Area2D = $Ball
@onready var paddle1: Area2D = $Paddle1
@onready var paddle2: Area2D = $Paddle2

var score = 0
var high_score = 0
var start_player = 1

var player_amount = 1

var player1_mistakes = 0
var player2_mistakes = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball.failed.connect(failed)
	ball.diverted.connect(increase_score)
	$HUD/Start.pressed.connect(start)
	$HUD/Winner.hide()
	$Ball.hide()
	$HUD/Turn.hide()
	$HUD/Player1Mistakes.hide()
	$HUD/Player2Mistakes.hide()
	$HUD/Score.hide()
	$HUD/HighScore.hide()
	"""
	$Paddle1.hide()
	$Paddle2.hide()
	$Arena.hide()
	"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ball.ball_speed == 0 and ball.is_game_over == false:
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
			if player_amount > 1:
				if start_player == 1:
					start_player = 2
				else:
					start_player = 1

func failed():
	if score > high_score:
		high_score = score
		$HUD/HighScore.text = str(high_score) + " HIGH SCORE"
	
	if player_amount > 1:
		if ball.turn == 1:
			player1_mistakes += 1
			$HUD/Player1Mistakes.text = "Player 1 Mistakes: " + str(player1_mistakes)
		else:
			player2_mistakes += 1
			$HUD/Player2Mistakes.text = "Player 2 Mistakes: " + str(player2_mistakes)
		if player1_mistakes == 3:
			$HUD/Winner.text = "Player 2 WON!!!"
			$HUD/Start.show()
			$HUD/Winner.show()
			$HUD/PlayerAmount.show()
			ball.is_game_over = true
			ball.ball_speed == 0
		elif player2_mistakes == 3:
			$HUD/Winner.text = "Player 1 WON!!!"
			$HUD/Winner.show()
			$HUD/Start.show()
			$HUD/PlayerAmount.show()
			ball.is_game_over = true
			ball.ball_speed == 0
		elif ball.is_game_over == false:
			new_game()
	elif ball.is_game_over == false:
		$HUD/Start.show()
		$HUD/PlayerAmount.show()
		ball.is_game_over = true
		print("failed")

func new_game():
	$HUD/Start.hide()
	print("new game")
	ball.position = Vector2(575, 323.5)
	ball.adjust_speed = true
	score = 0
	ball.ball_speed = 0
	$HUD/Score.text = str(score) + " Score"

func increase_score():
	score += 1
	$HUD/Score.text = str(score) + " Score"
	if player_amount > 1:
		$HUD/Turn.text = "Player Turn: " + str(ball.turn)

func start():
	print("start")
	ball.position = Vector2(575, 323.5)
	ball.ball_speed = 0
	player_amount = int($HUD/PlayerAmount.value)
	ball.player_amount = player_amount
	ball.is_game_over = false
	ball.adjust_speed = true
	$HUD/Winner.hide()
	$HUD/Start.hide()
	$HUD/PlayerAmount.hide()
	$Ball.show()
	$Paddle2.hide()
	$HUD/Turn.hide()
	$HUD/Player1Mistakes.hide()
	$HUD/Player2Mistakes.hide()
	ball.turn = 1
	start_player = 1
	if player_amount > 1:
		player1_mistakes = 0
		player2_mistakes = 0
		$HUD/Player1Mistakes.text = "Player 1 Mistakes: " + str(player1_mistakes)
		$HUD/Player2Mistakes.text = "Player 2 Mistakes: " + str(player2_mistakes)
		$HUD/Turn.text = "Player Turn: " + str(ball.turn)
		$HUD/Turn.show()
		$HUD/Player1Mistakes.show()
		$HUD/Player2Mistakes.show()
		$Paddle2.show()
	score = 0
	$HUD/Score.text = "0 Score"
	$HUD/Score.show()
	$HUD/HighScore.show()
