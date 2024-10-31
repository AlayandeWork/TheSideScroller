extends  CharacterBody2D

var player = null
var enemySpeed = 100

var health = 100
var enemyAttackAmount = 20
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_timer = $Timer

func _process(delta):
	if player:
		followPlayer(delta)
	else:
		animated_sprite.play("enemyFly")

func followPlayer(delta):
	if player != null:
		var direction = (player.position - position).normalized()
		velocity = direction * enemySpeed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
	#var direction = (player.position - position).normalized()
	#velocity = direction * enemySpeed
	#move_and_slide()
	
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


func _on_area_2d_2_area_entered(area):
	if area.is_in_group("enemyattacking"):
		area.get_parent().playerDamaging(enemyAttackAmount)
		damage_timer.start()


func _on_area_2d_2_area_exited(area):
	if area.is_in_group("enemyattacking"):
		player = null
		damage_timer.stop()


func _on_timer_timeout():
	if player:  # Ensure player is still in the area
		player.playerDamaging(enemyAttackAmount)  # Call damage function on the player
