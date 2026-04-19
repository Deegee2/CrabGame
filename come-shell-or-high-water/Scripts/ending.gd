extends Area3D

@export var ending_scene : String
@onready var gpu_particles_3d: GPUParticles3D = $"../GPUParticles3D"

func start_particles():
	gpu_particles_3d.emitting = true

func _on_area_entered(area: Area3D) -> void:
	if GlobalVariables.memories_acquired >= 3:
		call_deferred("start_ending")

func start_ending():
	get_tree().change_scene_to_file(ending_scene)
