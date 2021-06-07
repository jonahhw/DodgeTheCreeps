extends CanvasLayer

signal start_game(difficulty)
	
func game_restart():
	$MessageLabel.text = "Dodge the Creeps"
	$MessageLabel.show()
	yield(get_tree().create_timer($MessageTimer.wait_time), "timeout")
	$ButtonEasy.show()
	$ButtonNormal.show()

func update_score(score: int):
	$ScoreLabel.text = str(score)
	
func show_message(message: String):
	$MessageLabel.text = message
	$MessageLabel.show()
	$MessageTimer.start()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_Button_pressed(difficulty: int):
	$ButtonEasy.hide()
	$ButtonNormal.hide()
	$MessageLabel.hide()
	update_score(0)
	emit_signal("start_game", difficulty)

