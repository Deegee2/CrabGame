extends Camera3D

@export var follow_target: Node3D
@export var look_target: Node3D
@export var smoothing_speed: float = 5.0

func _process(delta):
	if follow_target:
		# Calculate target position with offset
		var target_position = follow_target.global_position + Vector3(0, 2, 25)
		# Smoothly interpolate current position to target
		global_position = global_position.lerp(target_position, smoothing_speed * delta)
		
		# Look at the target
		if look_target:
			look_at(look_target.global_position)
