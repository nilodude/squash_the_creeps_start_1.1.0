extends CharacterBody3D

signal squashed
signal gotHit

@export var min_speed = 10

@export var max_speed = 18

var target_velocity = velocity
var hitVel = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if(hitVel != Vector3.ZERO):
		if hitVel.x > 0:
			direction.x += 1
		if hitVel.x < 0:
			direction.x -= 1
		if hitVel.z > 0:
			direction.z += 1
		if hitVel.z < 0:
			direction.z -= 1
			
		if direction != Vector3.ZERO:
			direction = direction.normalized()
			$Pivot.look_at(position + direction, Vector3.UP)

		target_velocity.x = direction.x * 20
		target_velocity.z = direction.z * 20
		
		target_velocity.x = target_velocity.x - (5 * delta)
		target_velocity.z = target_velocity.z - (5 * delta)
		
		
		velocity=target_velocity
		
		hitVel = Vector3.ZERO
	
	move_and_slide()
	
	
func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)



func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()

func receiveHit(vel):
	hitVel = vel
	gotHit.emit()
