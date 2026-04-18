extends Camera3D

@export var target_path: NodePath # Assign your Player (CharacterBody3D) here
@export var offset: Vector3 = Vector3(0, 0, 10) # X, Y, Z offset
@export var smoothness: float = 0.1 # Lower is smoother/slower

var target: Node3D

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(_delta):
	if target:
		# Calculate where the camera SHOULD be
		var target_pos = target.global_position + offset
		
		# Smoothly move the camera to that position
		global_position = global_position.lerp(target_pos, smoothness)
		
		# Optional: Keep the camera looking at the player
		# look_at(target.global_position)
