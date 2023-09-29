extends Label

signal levelup

var score = 0

func _on_mob_squashed():
	score += 1
	text = "Score: %s" % score
	
	if(score > 10):
		score = 0
		levelup.emit()
