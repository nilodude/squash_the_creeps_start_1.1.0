extends CharacterBody3D

signal squashed
signal spawned
signal outBounds
signal gotHit

@export var min_speed = 10
@export var max_speed = 18

var target_velocity = velocity
var hitVel = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	var minus = randi_range(-1, 1)
	var randangle = randf_range(-PI/4, PI/4)
	if(hitVel != Vector3.ZERO):
		direction.x += velocity.x + hitVel.x
		direction.z += velocity.z + hitVel.z
			
		if direction != Vector3.ZERO:
			direction = direction.normalized()
#			$Pivot.look_at(position + direction, Vector3.UP)

		target_velocity.x = direction.x * 20
		target_velocity.z = direction.z * 20
		target_velocity.y = 15
		
		target_velocity.x = target_velocity.x - (1 * delta)
		target_velocity.z = target_velocity.z - (1 * delta)
		target_velocity.y = target_velocity.y - (1 * delta)
		
		velocity=target_velocity
		
		hitVel = Vector3.ZERO
		
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
			velocity.y = velocity.y - (50 * delta)
			rotate_y(minus*PI/8  + (randangle * delta))
			rotate_x(minus * PI/8  - (randangle * delta))
			
	move_and_slide()
	
	
func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_entered():
	spawned.emit()

func _on_visible_on_screen_notifier_3d_screen_exited():
	outBounds.emit()
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()

func receiveHit(vel):
	hitVel = vel
	gotHit.emit()
