extends CharacterBody2D

# Player Variables
var speed = 190
var jumpPower = 245g
var gravity = 1000

func _physics_process(delta):
	
	# Apply gravity to the player
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	
	# Player movement Left & Right
	var playerDirection = Input.get_axis("Left","Right")
	
	if playerDirection:
		velocity.x = speed * playerDirection
	else:
		velocity.x = 0
		
		
		
	# Player Jump
	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			velocity.y -= jumpPower
			
			
	move_and_slide()
