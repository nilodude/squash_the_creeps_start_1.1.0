extends Label

var shit = 0

func _on_mob_spawned():
	shit = get_tree().get_nodes_in_group("mob").size()
	text = "Shit: %s" % shit

func _on_mob_squashed():
	shit = get_tree().get_nodes_in_group("mob").size()
	text = "Shit: %s" % shit

func _on_mob_out():
	shit = get_tree().get_nodes_in_group("mob").size()
	text = "Shit: %s" % shit

func increment():
	shit += 1
	text = "Shit: %s" % shit
	
func decrement():
	shit -= 1
	text = "Shit: %s" % shit
