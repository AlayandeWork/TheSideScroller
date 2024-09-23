extends CharacterBody2D

# Player Variables
var speed = 190
var jumpPower = 370
var gravity = 1000
var currentDirection = 1 
var playerAttacking = false

func _physics_process(delta):
	
	# Apply gravity to the player
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	
	# Player movement Left & Right
	var playerDirection = Input.get_axis("Left","Right")
	
	
	# Check player is on the floor
	if is_on_floor():
		# Player Jumping
		if Input.is_action_just_pressed("Jump") and playerAttacking == false:
			# Adjusting the jump power
			velocity.y -= jumpPower
			$AnimationPlayer.play("Jump")
		 # Player Running
		elif playerDirection and playerAttacking == false:
			velocity.x = speed * playerDirection
			if playerDirection > 0:
				currentDirection = 1 # Facing Right
				$AnimationPlayer.play("rightRun")
			else:
				currentDirection = -1 # Facing Left
				$AnimationPlayer.play("leftRun")
		else:
		# Player Idley
			velocity.x = 0
			if playerAttacking == false:
				if currentDirection > 0:
					$AnimationPlayer.play("IdleRight")
				else:
					$AnimationPlayer.play("IdleLeft")
	
	# Check player not on the floor
	else:
		# Player Falling
		if velocity.y > 0:
			$AnimationPlayer.play("Fall")
		# Player Jumping
		else:
			$AnimationPlayer.play("Jump")
			
			
	if Input.is_action_just_pressed("Attack") and is_on_floor():
		playerAttacking = true
		if currentDirection > 0:
			$AnimationPlayer.play("attackRight")
		else:
			$AnimationPlayer.play("attackLeft")
			
	move_and_slide()

# Function for animation finished
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attackRight" or anim_name == "attackLeft":
		playerAttacking = false
