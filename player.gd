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
	
	if not moveDisabled:
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	else:
		target_velocity.x = direction.x * 0
		target_velocity.z = direction.z * 0
		
	if not is_on_floor(): # FALLING. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		$AnimationPlayer.speed_scale = 1.5
		$Pivot.rotation.x = PI / 10 * target_velocity.y / jump_impulse 
		$Pivot/avion/Plane.rotation.z = -PI - PI * target_velocity.y / 25 # por la stance del robot (switch) -> poisitivo heelflip, negativo kickflip
	else:	# JUMPING.
		$Pivot.rotation.x = $Pivot.rotation.x - $Pivot.rotation.x/2
		$Pivot/avion/Plane.rotation.z = $Pivot/avion/Plane.rotation.z - $Pivot/avion/Plane.rotation.z/2
		$Pivot/avion/Plane.position.y = $Pivot/robo/Circle_004.position.y - 0.5
		$Pivot/robo/Circle_004.position.y = $Pivot/avion/Plane.position.y + 0.5		
		
	if Input.is_action_just_pressed("jump"):
			target_velocity.y = jump_impulse
			$Pivot/avion/Plane.position.y = $Pivot/robo/Circle_004.position.y - 0.9	
			$Pivot/robo/Circle_004.position.y = $Pivot/avion/Plane.position.y + 0.9	
	
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
				$Pivot/avion/Plane.position.y = $Pivot/robo/Circle_004.position.y - 0.9	
				$Pivot/robo/Circle_004.position.y = $Pivot/avion/Plane.position.y + 0.9	
				mob.squash()
			else:
				mob.receiveHit(target_velocity)
					
	
	velocity = target_velocity
	
		
	if position.y < -30:
		die.emit()
		
	move_and_slide()
