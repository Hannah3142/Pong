extends Node2D

# canvas dimensions: 648, 1152
@onready var ball: Area2D = $Ball
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
	pass

func failed():
	$HUD/Restart.show()
	if score > high_score:
		high_score = score
	$HUD/HighScore.text = str(high_score) + "HIGH SCORE"

func new_game():
	$HUD/Restart.hide()
	ball.position = Vector2(600, 300)
	ball.ball_speed = 3
	ball.angle = randi_range(0, 359)
	ball.is_game_over = false
	ball.adjust_speed = true
	score = 0
	$HUD/Score.text = str(score) + " Score"

func increase_score():
	score += 1
	$HUD/Score.text = str(score) + " Score"
