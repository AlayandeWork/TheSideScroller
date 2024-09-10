extends CharacterBody2D

# Player Variables
var speed = 190
var jumpPower = 350
var gravity = 1000

func _physics_process(delta):
	
	# Apply gravity to the player
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	
	# Player movement Left & Right
	var playerDirection = Input.get_axis("Left","Right")
	
	
	# Check player is on the floor
	if is_on_floor():
		# Player Jumping
		if Input.is_action_just_pressed("Jump"):
			velocity.y -= jumpPower
			$AnimationPlayer.play("Jump")
		 # Player running (Left or Right)
		elif playerDirection:
			velocity.x = speed * playerDirection
			if playerDirection > 0:
				$AnimationPlayer.play("rightRun")
			else:
				$AnimationPlayer.play("leftRun")
		else:
			# Player Idling
			velocity.x = 0
			$AnimationPlayer.play("Idle")
	
	# Checks if the player is not on the floor			
	else:
		# Player Falling
		if velocity.y > 0:
			$AnimationPlayer.play("Fall")
		# Player Jumping
		else:
			$AnimationPlayer.play("Jump")
			
	move_and_slide()
