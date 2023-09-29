extends Node

@export var mob_scene: PackedScene
var mobSize = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$UserInterface/Retry.hide()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func fall():
	$UserInterface/Retry/gameoverLabel.text = "TA CAIO"
	game_over()

func game_over():
	$MobTimer.stop()
	$Player.moveDisabled = true
	$UserInterface/Retry.show()

func _on_mob_timer_timeout():
	if(mobSize > 10):
		$UserInterface/Retry/gameoverLabel.text = 'TOO MUCH SHIT'
		game_over()
	else:	
		var mob = mob_scene.instantiate()
		var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
		mob_spawn_location.progress_ratio = randf()
	
		var player_position = $Player.position
		mob.initialize(mob_spawn_location.position, player_position)
	
		mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
		mob.squashed.connect($UserInterface/ShitLabel._on_mob_squashed.bind())
		mob.squashed.connect($Player._on_mob_squashed.bind())
		
		mob.outBounds.connect($UserInterface/ShitLabel._on_mob_out.bind())
		mob.spawned.connect($UserInterface/ShitLabel._on_mob_spawned.bind())
		
		add_child(mob)
		mobSize = get_tree().get_nodes_in_group("mob").size()
