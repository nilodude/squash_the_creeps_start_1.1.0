extends Label

var level = 0

func levelup():
	level += 1
	text = "Level %s" % level
