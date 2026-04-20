extends Control
@onready var sc_leave_house: Area3D = $SC_LeaveHouse/SC_LeaveHouse
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	GlobalVariables.memories_acquired = 0
	GlobalVariables.start_items_acquired = 0
	DialogueManager.connect("dialogue_ended",checkIfEnding)

func checkIfEnding(resource) -> void:
	if GlobalVariables.start_items_acquired >= 1:
		sc_leave_house.start_particles()

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
	pass # Replace with function body.
