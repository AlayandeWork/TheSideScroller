extends  CharacterBody2D

var player = null
var enemySpeed = 100

var health = 100

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	update_health()
	
	
func _process(delta):
	if player:
		followPlayer(delta)
	else:
		animated_sprite.play("enemyFly")

func followPlayer(delta):
	var direction = (player.position - position).normalized()
	velocity = direction * enemySpeed
	move_and_slide()
	
	if velocity.x > 0:
		animated_sprite.flip_h = true
	elif velocity.x < 0:
		animated_sprite.flip_h = false
	animated_sprite.play("enemyFly")
	
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body
		
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player = null
		
		
func Idleanimation():
	if 	animated_sprite.animation != "enemyFly":
		animated_sprite.play("enemyFly")
		
func take_damage(damage_amount):
	health -= damage_amount
	print(health)
	if health <= 0:
		die()
		
func die():
	queue_free()


func update_health():
	var enemyHealth = $ProgressBar
	
	enemyHealth.value = health
	
	
	
