extends Label

var level = 1

func levelup():
	level += 1
	text = "Level %s" % level
