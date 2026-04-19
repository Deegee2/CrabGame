extends CharacterBody2D


const SPEED = 50


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

var animation_state_machine: AnimationNodeStateMachinePlayback
var input_vector: Vector2 = Vector2.ZERO


func _ready() -> void:
	animation_tree.active = true
	animation_state_machine = animation_tree.get("parameters/playback")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			input_vector = Vector2.ZERO
	else:
		input_vector = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")


func _physics_process(_delta: float) -> void:
	if input_vector.length_squared() > 0:
		velocity = input_vector * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()

	if velocity.length_squared() > 0:
		animation_tree.set("parameters/idle/blend_position", velocity)
		animation_tree.set("parameters/walk/blend_position", velocity)
		animation_state_machine.travel("walk")
	else:
		animation_state_machine.travel("idle")


func look_down() -> void:
	animation_tree.set("parameters/idle/blend_position", Vector2.DOWN)


func reach_up() -> void:
	animation_tree.set("parameters/idle/blend_position", Vector2.UP);
	animation_tree.active = false;
	animation_player.play("reach_up");
	await animation_player.animation_finished
	animation_tree.active = true;
