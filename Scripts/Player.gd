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
	
	
	# On the floor and not on the floor
	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			velocity.y -= jumpPower
			$AnimationPlayer.play("Jump")
		elif playerDirection:
			velocity.x = speed * playerDirection
			if playerDirection > 0:
				$AnimationPlayer.play("rightRun")
			else:
				$AnimationPlayer.play("leftRun")
		else:
			velocity.x = 0
			$AnimationPlayer.play("Idle")
	else:
		if velocity.y > 0:
			$AnimationPlayer.play("Fall")
		else:
			$AnimationPlayer.play("Jump")
		
	
			
			
	move_and_slide()
