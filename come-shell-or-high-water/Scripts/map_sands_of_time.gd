extends Control
@onready var end_flee: Node3D = $End_Flee/Ending_Flee
@onready var end_wedding: Node3D = $End_Wedding/Ending_Wedding


func _ready() -> void:
	DialogueManager.connect("dialogue_ended",checkIfEnding)

func checkIfEnding(resource) -> void:
	if GlobalVariables.memories_acquired >= 3:
		end_flee.start_particles()
		end_wedding.start_particles()

func _process(delta: float) -> void:
	print(GlobalVariables.memories_acquired)

func add_characters(character_name):
	GlobalVariables.characters_in_scene.append(character_name)

func print_characters():
	print(GlobalVariables.characters_in_scene)

func erase_characters():
	GlobalVariables.characters_in_scene.clear()
