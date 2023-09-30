extends CharacterBody3D

signal die
signal levelup

@export var speed = 18
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var jump_impulse = 25
@export var bounce_impulse = 15
@export var moveDisabled = false

var prevDot = 0;

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 1.5
	else:
		$AnimationPlayer.speed_scale = 0.8

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor(): # FALLING. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		$AnimationPlayer.speed_scale = 1.5
		$Pivot.rotation.x = PI / 10 * target_velocity.y / jump_impulse
#		$Pivot.rotation.z = PI + PI * target_velocity.y / 25
	else:	# JUMPING.
		$Pivot.rotation.x = $Pivot.rotation.x - $Pivot.rotation.x/2
#		$Pivot.rotation.z = $Pivot.rotation.z - $Pivot.rotation.z/2
		
	if Input.is_action_just_pressed("jump"):
			target_velocity.y = jump_impulse	
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		if (collision.get_collider() == null):
			continue
		
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			var normal = collision.get_normal()
			var upDotProduct = Vector3.UP.dot(normal)
	
		# landing on enemy from above (when vectors are pointing similar directions, dot product between them is a high value)
			if  upDotProduct > 0.7 && prevDot != upDotProduct:
				prevDot = upDotProduct
				target_velocity.y = bounce_impulse
				mob.squash()
			else:
				mob.receiveHit(target_velocity)
					
	
	velocity = target_velocity
		
	if position.y < -30:
		die.emit()
		
	if not moveDisabled:
		move_and_slide()
