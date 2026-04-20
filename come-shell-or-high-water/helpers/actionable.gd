extends Area3D

@onready var crabeau: CharacterBody3D = $"../../Crabeau"
var hasbeeninteracted = false
@onready var object_area: Area3D = $"."
@onready var player_interact: AudioStreamPlayer = $"../player_interact"


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func action() -> void:
	crabeau.is_talking = true
	hasbeeninteracted = true
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	print("Crabeau is yappin'")
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)


func _on_area_entered(area: Area3D) -> void:
	player_interact.play()
	pass # Replace with function body.
