extends CharacterBody2D

const SPEED = 300.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animatedSprite2d = $AnimatedSprite2D


func _ready():
	animatedSprite2d.play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			animatedSprite2d.flip_h = false
			animatedSprite2d.play("Run")
		elif velocity.x < 0:
			animatedSprite2d.flip_h = true
			animatedSprite2d.play("Run")
	else:
		animatedSprite2d.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# Handle Jump.
	if Input.is_action_just_pressed("Jump"):
		velocity.y = JUMP_FORCE
		animatedSprite2d.play("Jump")

	move_and_slide()
