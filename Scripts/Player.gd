extends CharacterBody2D

# Player Status
var playerHealth  = 100
var attackDamage = 20
@onready var main_progress_bar = $"../CanvasLayer/ProgressBar"

# Player Movement Constants
var speed = 190
var jumpPower = 370
var gravity = 1000
var knockBackForce = 150

# State Variables
var currentDirection = 1
var playerAttacking = false
var isDead = false
var isHit = false
var health_increase = false

func _process(delta: float):
	if health_increase and playerHealth < 100:
		playerHealth += 10 * delta
		if playerHealth >= 100:
			playerHealth = 100
		print ("new player health = ", playerHealth)

func _physics_process(delta):
	player_health_update()
	
	# Apply gravity if in the air
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if isHit:
		apply_knockback(delta)
	
	# Player movement
	var playerDirection = Input.get_axis("Left","Right")
	
	# Check player is on the floor
	if is_on_floor() and not isDead and not isHit:
		if Input.is_action_just_pressed("Jump") and not playerAttacking:
			velocity.y =- jumpPower
			$AnimationPlayer.play("Jump")
		elif playerDirection and not playerAttacking:
			move_horizontally(playerDirection)
		else:
			idle_animation()
	else:
		if not isDead and not isHit:
			$AnimationPlayer.play("Fall" if velocity.y > 0 else "Jump")
			
			
	if Input.is_action_just_pressed("Attack") and is_on_floor() and not isDead and not isHit:
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
	elif anim_name == "Death":
		get_tree().reload_current_scene()
	elif anim_name == "Hit":
		isHit = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemygroup") and playerAttacking:
		area.get_parent().take_damage(attackDamage)
	
	
# Function for player damage	
func take_damage(damage_amount):
	if isDead:
		return
	playerHealth -= damage_amount
	print(playerHealth)
	
	if playerHealth <= 0:
		die()
	else:
		isHit = true
		$AnimationPlayer.play("Hit")
		initial_knockback()
			
# Function for player death	
func die():
	isDead = true
	$AnimationPlayer.play("Death")

# Function for player health update
func player_health_update():
	main_progress_bar.value = playerHealth

func initial_knockback():
	velocity.x = -knockBackForce * currentDirection

func apply_knockback(delta):
	velocity.x = lerp(velocity.x, 0.0, 5 * delta)


func _on_health_zone_body_entered(body):
	if body.name == "Player":
		health_increase = true
		


func _on_health_zone_body_exited(body):
	if body.name == "Player":
		health_increase = false
