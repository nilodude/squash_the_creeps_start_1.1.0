extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$UserInterface/Retry.hide()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func game_over():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mobSize = get_tree().get_nodes_in_group("mob").size()
	
	if(mobSize > 20):
		game_over()
	else:	
		var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
		mob_spawn_location.progress_ratio = randf()
	
		var player_position = $Player.position
		mob.initialize(mob_spawn_location.position, player_position)
	
		mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	
		add_child(mob)
