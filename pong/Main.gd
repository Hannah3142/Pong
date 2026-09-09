extends Node2D

# canvas dimensions: 648, 1152
# center Vector2(575, 323.5)

@onready var ball: Area2D = $Ball

var paddle_scene = preload("res://Paddle.tscn")

var paddles: Array[Paddle] = []

var score = 0
var high_score = 0
var start_player = 1

var player_amount = 1

var mistakes_text = ""
var player_mistakes = []
var loser_list = []
var game_started = false

func _ready() -> void:
	ball.failed.connect(failed)
	ball.diverted.connect(diverted)
	ball.adjustz.connect(adjust_z)
	$HUD/Start.pressed.connect(start)
	$HUD/Winner.hide()
	$Ball.hide()
	$HUD/Turn.hide()
	$HUD/PlayerMistakes.hide()
	$HUD/Score.hide()
	$HUD/HighScore.hide()
	queue_redraw()
	spawn_paddles(1)

func _process(delta: float) -> void:
	if ball.ball_speed == 0 and game_started == true:
		var paddle = paddles[start_player-1]
		var paddle_rotation = paddle.rotation
		ball.position = Vector2(575+215*cos(paddle_rotation), 323.5+215*sin(paddle_rotation))
		if (start_player == 1 and Input.is_key_pressed(KEY_UP)) or (start_player == 2 and Input.is_key_pressed(KEY_W)) or (start_player == 3 and Input.is_key_pressed(KEY_U)): ###
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
	if score > high_score:
		high_score = score
		$HUD/HighScore.text = str(high_score) + " HIGH SCORE"
	
	if player_amount > 1:
		player_mistakes[ball.turn-1] += 1
		mistakes_text = ""
		for i in player_amount:
			mistakes_text += "Player " + str(i+1) + " Mistakes: " + str(player_mistakes[i]) + "\n"
			if player_mistakes[i] == 3:
				get_node("Paddle"+str(i+1)).hide()
				loser_list.append(i+1)
		$HUD/PlayerMistakes.text = mistakes_text
		if len(loser_list) == player_amount-1:
			loser_list.sort()
			for i in player_amount:
				if i+1 not in loser_list:
					$HUD/Winner.text = "Player " + str(i+1) + " WON!!!"
					break
			$HUD/Winner.show()
			$HUD/Start.show()
			$HUD/PlayerAmount.show()
			game_started = false
		else:
			ball.turn = int(wrapf(ball.turn+1, 1, player_amount+1))
			while ball.turn in loser_list:
				ball.turn = int(wrapf(ball.turn+1, 1, player_amount+1))
			start_player = int(wrapf(ball.turn+1, 1, player_amount+1))
			while start_player in loser_list or start_player == ball.turn:
				start_player = int(wrapf(start_player+1, 1, player_amount+1))
			$HUD/Turn.text = "Player Turn: " + str(ball.turn)
			new_game()
	else:
		$HUD/Start.show()
		$HUD/PlayerAmount.show()
		game_started = false

func new_game():
	$HUD/Start.hide()
	ball.position = Vector2(575, 323.5)
	ball.adjust_speed = true
	ball.ball_speed = 0
	score = 0
	$HUD/Score.text = str(score) + " Score"

func diverted():
	score += 1
	$HUD/Score.text = str(score) + " Score"
	if player_amount > 1:
		ball.turn = int(wrapf(ball.turn+1, 1, player_amount+1))
		while ball.turn in loser_list:
			ball.turn = int(wrapf(ball.turn+1, 1, player_amount+1))
		start_player = int(wrapf(ball.turn+1, 1, player_amount+1))
		while start_player in loser_list or start_player == ball.turn:
			start_player = int(wrapf(start_player+1, 1, player_amount+1))
		$HUD/Turn.text = "Player Turn: " + str(ball.turn)

func start():
	ball.position = Vector2(575, 323.5)
	ball.ball_speed = 0
	player_amount = int($HUD/PlayerAmount.value)
	ball.player_amount = player_amount
	ball.adjust_speed = true
	mistakes_text = ""
	player_mistakes = []
	loser_list = []
	$HUD/Winner.hide()
	$HUD/Start.hide()
	$HUD/PlayerAmount.hide()
	$Ball.show()
	$HUD/Turn.hide()
	$HUD/PlayerMistakes.hide()
	start_player = randi_range(1, player_amount)
	if player_amount == 1:
		ball.turn = 1
	else:
		ball.turn = int(wrapf(start_player+1, 1, player_amount+1))
	if player_amount > 1:
		for i in player_amount:
			player_mistakes.append(0)
			mistakes_text += "Player " + str(i+1) + " Mistakes: " + str(player_mistakes[i]) + "\n"
		$HUD/PlayerMistakes.text = mistakes_text
		$HUD/Turn.text = "Player Turn: " + str(ball.turn)
		$HUD/Turn.show()
		$HUD/PlayerMistakes.show()
	score = 0
	$HUD/Score.text = "0 Score"
	$HUD/Score.show()
	$HUD/HighScore.text = str(high_score) + " Score"
	$HUD/HighScore.show()
	spawn_paddles(player_amount)
	game_started = true
	adjust_z()

func spawn_paddles(n: int):
	paddles.clear()
	for child in get_children():
		if child is Paddle:
			child.free()
	var colors = [Color.LAVENDER, Color.BLANCHED_ALMOND, Color.LIGHT_CYAN, Color.DARK_SEA_GREEN, Color.MEDIUM_TURQUOISE]
	var controls = ["arrows", "ad", "hk"]
	for i in n:
		var paddle = paddle_scene.instantiate() as Paddle
		paddle.setup("Paddle"+str(i+1), colors[i], controls[i], (i+1)*360/n)
		add_child(paddle)
		paddles.append(paddle)

func adjust_z():
	if player_amount > 1:
		$HUD/Turn.text = "Player Turn: " + str(int(ball.turn))
	for i in player_amount:
		var paddle = paddles[i]
		if i+1 == ball.turn:
			paddle.z_index = 5
		else:
			paddle.z_index = 0

func _draw():
	draw_circle(Vector2(575, 323.5), 250, Color(0.35, 0.35, 0.35, 1), false, 20.0)
