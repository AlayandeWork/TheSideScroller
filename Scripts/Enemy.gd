extends  CharacterBody2D

# References to player and enemy attributes
var player = null
var enemySpeed = 100
var health = 100
var attack_damage = 20

# Node References
@onready var animated_sprite = $AnimatedSprite2D
@onready var DamageClock = $Timer	
@onready var health_bar_timer = $health_bar_timer
@onready var enemy_health_bar = $enemyHealthBar

func _ready():
	enemy_health_bar.visible = false
func _process(delta):
	# For calling functions
	enemyHealthBar()

	
	if player:
		followPlayer(delta)
	else:
		play_idle_animation()

func followPlayer(delta):
	if player != null:
		var direction = (player.position - position).normalized()
		velocity = direction * enemySpeed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	
	
	if velocity.x > 0:
		animated_sprite.flip_h = true
	elif velocity.x < 0:
		animated_sprite.flip_h = false
	animated_sprite.play("enemyFly")

func play_idle_animation():
	velocity = Vector2.ZERO
	animated_sprite.play("enemyFly")
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body
		enemy_health_bar.visible = true
		
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player = null
		health_bar_timer.start()
		
		
func Idleanimation():
	if 	animated_sprite.animation != "enemyFly":
		animated_sprite.play("enemyFly")
		
func enemyHealthBar():
	var enemyHealth = $enemyHealthBar
	enemyHealth.value = health


func take_damage(damage_amount):
	health -= damage_amount
	print(health)
	if health <= 0:
		die()
		
			
func die():
	queue_free()


func _on_damage_player_area_area_entered(area):
	if area.is_in_group("enemycandamage"):
		area.get_parent().take_damage(attack_damage)
		DamageClock.start()


func _on_damage_player_area_area_exited(area):
	if area.is_in_group("enemycandamage"):
		player = null
		DamageClock.stop()


func _on_timer_timeout():
	if player:
		player.take_damage(attack_damage)


func _on_health_bar_timer_timeout():
	enemy_health_bar.visible = false
	health = 100


func _on_health_zone_area_exited(area):
	pass # Replace with function body.
