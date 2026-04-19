extends Area3D

@onready var crabeau: CharacterBody3D = $"../../Crabeau"
var hasbeeninteracted = false
@onready var object_area: Area3D = $"."


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func action() -> void:
	crabeau.is_talking = true
	hasbeeninteracted = true
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	print("Crabeau is yappin'")
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
