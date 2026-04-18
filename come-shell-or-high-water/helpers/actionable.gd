extends Area3D
@onready var crabeau: CharacterBody3D = $"../../Crabeau"


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func action() -> void:
	crabeau.is_talking = true
	print("Crabeau is yappin'")
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
