extends Control
#@onready var end_flee: Node3D = $End_Flee/Ending_Flee
#@onready var end_wedding: Node3D = $End_Wedding/Ending_Wedding
@onready var audio_stream_player: AudioStreamPlayer = $bgm
@onready var ambience: AudioStreamPlayer = $ambience
@onready var end_flee_particles: GPUParticles3D = $End_Flee/GPUParticles3D
@onready var end_wedding_particles: GPUParticles3D = $End_Wedding/GPUParticles3D


func _ready() -> void:
	DialogueManager.connect("dialogue_ended",checkIfEnding)

func checkIfEnding(resource) -> void:
	if GlobalVariables.memories_acquired >= 3:
		end_flee_particles.emitting = true
		end_wedding_particles.emitting = true

#func _process(delta: float) -> void:
	#print(GlobalVariables.memories_acquired)

func add_characters(character_name):
	GlobalVariables.characters_in_scene.append(character_name)

func print_characters():
	print(GlobalVariables.characters_in_scene)

func erase_characters():
	GlobalVariables.characters_in_scene.clear()


func _on_audio_stream_player_finished() -> void:
	audio_stream_player.play()


func _on_ambience_finished() -> void:
	ambience.play()
