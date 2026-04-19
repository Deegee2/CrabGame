extends CharacterBody3D

@onready var sprite: AnimatedSprite3D = $Sprite

var flip_speed : float = 15.0
var is_facing_right : bool = true
var is_talking : bool = false
@export var speed: float = 10.0
@export var gravity: float = 9.8

var min_x = -75  # The left edge of your 3D window
var max_x = 75 # The right edge
var min_z = -20 # background max
var max_z = 35 # foreground max
var clamping_buffer = 0.8

# placeholder flags for each item
var item_one_get : bool = false
var item_two_get : bool = false
var item_three_get : bool = false
var item_four_get : bool = false
var item_five_get : bool = false
var item_six_get : bool = false
var item_seven_get : bool = false

func _ready():
	DialogueManager.connect("dialogue_ended",finishedScene)

func _physics_process(delta):
	# 1. The Guard Clause: If we are talking, stop processing movement logic.
	if is_talking:
		# Prevents Crabeau from moving while he's talking
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		move_and_slide() 
		return # Exits all movement function

	# The rest only runs if he's not talking
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Flip logic
	if input_dir.x > 0.0:
		is_facing_right = true
	elif input_dir.x < 0.0:
		is_facing_right = false
		
	if is_facing_right:
		sprite.rotation_degrees.y = move_toward(sprite.rotation_degrees.y, 0.0, flip_speed)
	else:
		sprite.rotation_degrees.y = move_toward(sprite.rotation_degrees.y, 180.0, flip_speed)
	
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
		
		# Clamping Logic
	position.x = clamp(position.x, min_x + clamping_buffer, max_x - clamping_buffer)
	position.z = clamp(position.z, min_z + clamping_buffer, max_z - clamping_buffer)
	move_and_slide()


func _on_actionable_area_entered(area: Area3D) -> void:
	if area.name == "ObjectArea":
		area.action()

func finishedScene(_resource: DialogueResource):
	#Regain player's control after dialogue has ended
	is_talking = false
	print("Crabeau has finished yappin'")
	pass
