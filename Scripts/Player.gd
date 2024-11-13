extends CharacterBody2D

# Player Status
var playerHealth  = 100
var attackDamage = 20

# Player Movement Constants
var speed = 190
var jumpPower = 370
var gravity = 1000

# State Variables
var currentDirection = 1
var playerAttacking = false


func _physics_process(delta):
	player_health_update()
	
	
	# Apply gravity if in the air
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	# Player movement
	var playerDirection = Input.get_axis("Left","Right")
	
	# Check player is on the floor
	if is_on_floor():
		if Input.is_action_just_pressed("Jump") and not playerAttacking:
			velocity.y =- jumpPower
			$AnimationPlayer.play("Jump")
		elif playerDirection and not playerAttacking:
			move_horizontally(playerDirection)
		else:
			idle_animation()
	else:
		$AnimationPlayer.play("Fall" if velocity.y > 0 else "Jump")
			
			
	if Input.is_action_just_pressed("Attack") and is_on_floor():
		playerAttacking = true
		$AnimationPlayer.play("attackRight" if currentDirection > 0 else "attackLeft")
			
	move_and_slide()
		
		
func move_horizontally(direction):
	velocity.x = speed * direction
	currentDirection = sign(direction)
	$AnimationPlayer.play("rightRun" if currentDirection > 0 else "leftRun")
		
func idle_animation():
	velocity.x = 0
	if not playerAttacking:
		$AnimationPlayer.play("IdleRight" if currentDirection > 0 else "IdleLeft")
		
		
		
# Function for animation finished
func _on_animation_player_animation_finished(anim_name):
	if anim_name in ["attackRight", "attackLeft"]:
		playerAttacking = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemygroup") and playerAttacking:
		area.get_parent().take_damage(attackDamage)
	
	
# Function for player damage	
func take_damage(damage_amount):
	playerHealth -= damage_amount
	print(playerHealth)
	if playerHealth <= 0:
		die()
			
# Function for player death	
func die():
	queue_free()

# Function for player health update
func player_health_update():
	$ProgressBar.value = playerHealth
