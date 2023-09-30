extends Label

signal levelup

var score = 0

func _on_mob_squashed():
	score += 1
	text = "Score: %s" % score

	if(score > 10):
		levelup.emit()

func reset():
	score = 0
	text = "Score: 0"
