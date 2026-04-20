extends Area3D

@onready var gpu_particles_3d: GPUParticles3D = $"../GPUParticles3D"
@export var in_house: bool

func start_particles():
	gpu_particles_3d.emitting = true

func _on_area_entered(area: Area3D) -> void:
	if GlobalVariables.start_items_acquired >= 1:
		print("Here")
		call_deferred("start_ending")

func start_ending():
	get_tree().change_scene_to_file("res://Scenes/map_sands_of_time.tscn")
