extends CharacterBody3D

@onready var sprite: AnimatedSprite3D = $Sprite

var flip_speed : float = 15.0
var is_facing_right : bool = true
@export var speed: float = 10.0
@export var gravity: float = 9.8

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Keeps crabeau on the ground
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handles left/right flipping	
	if input_dir.x > 0.0:
		is_facing_right = true
	elif input_dir.x < 0.0:
		is_facing_right = false
		
	if is_facing_right:
		sprite.rotation_degrees.y = move_toward(sprite.rotation_degrees.y, 0.0, flip_speed)
	else:
		sprite.rotation_degrees.y = move_toward(sprite.rotation_degrees.y, 180.00, flip_speed)
	
	# Handles movement on the x and z axis.
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()


func _on_actionable_area_entered(area: Area3D) -> void:
	area.action()
