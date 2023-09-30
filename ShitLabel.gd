extends Label

var shit = 0

func _on_mob_spawned():
	update()

func _on_mob_squashed():
	update()

func _on_mob_out():
	update()

func update():
	shit = get_tree().get_nodes_in_group("mob").size()
	text = "Shit: %s" % shit
	
func reset():
	text = "Shit: 0"
