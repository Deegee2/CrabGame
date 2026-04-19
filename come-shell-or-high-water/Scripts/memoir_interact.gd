extends Area3D
@onready var crabeau: CharacterBody3D = $Crabeau


func _on_body_entered(body):
	if body.is_in_group("Player"):
		
		hide_item()

func hide_item():
	# Disable collisions and visual
	set_deferred("monitoring", false) 
	visible = false
