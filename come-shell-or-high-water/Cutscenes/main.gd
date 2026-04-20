extends Control


const SLOT_LEFT = 0
const SLOT_RIGHT = 1

const STEP_START = "start"
const STEP_KNOWS_ABOUT_PART = "knows_about_part"
const STEP_HAS_CORRENT_PART = "has_correct_part"
const STEP_HAS_INCORRECT_PART = "has_incorrect_part"
const STEP_INSTALLED_PART = "installed_part"
const STEP_STILL_NOT_WORKING = "still_not_working"
const STEP_END = "end"

@export var dialogue_resource: DialogueResource

var dialogue_ended = false

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

var _is_waiting_for_input: bool = false

var _dialogue_line: DialogueLine:
	set(value):
		_dialogue_line = value
		_apply_dialogue_line()
	get:
		return _dialogue_line

## The current location
var location: String = "space"

var story_step: String = STEP_START
var slots: Array[Marker2D] = []
var characters: Dictionary = {}

@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = $ResponsesMenu
@onready var location_background: TextureRect = %LocationBackground
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var slot_0: Marker2D = %Slot0
@onready var slot_1: Marker2D = %Slot1


func _ready() -> void:
	slots = [slot_0, slot_1]

	location = "space"

	character_label.text = ""
	dialogue_label.text = ""
	responses_menu.hide()

	_dialogue_line = await dialogue_resource.get_next_dialogue_line("start")
	
	animation_player.play("RESET")
	DialogueManager.connect("dialogue_ended",restartGame)


#region Dialogue

func restartGame(resource):
	dialogue_ended = true
	get_tree().change_scene_to_file("res://Scenes/map_chateau_de_crabeau.tscn")

func _apply_dialogue_line() -> void:
	_is_waiting_for_input = false
	focus_mode = Control.FOCUS_ALL
	if !dialogue_ended:
		grab_focus()

	if not is_instance_valid(_dialogue_line):
		character_label.text = ""
		dialogue_label.text = ""
		return

	if _dialogue_line.character.is_empty():
		character_label.text = ""
		#dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_dialogue_line.text = "[color=#4cc69c]%s[/color]" % [_dialogue_line.text]
	else:
		character_label.text = tr(_dialogue_line.character, "dialogue")
		#dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

		if characters.has(_dialogue_line.character.to_lower()):
			characters[_dialogue_line.character.to_lower()].emote(_dialogue_line.tags)

	responses_menu.hide()
	responses_menu.responses = _dialogue_line.responses

	dialogue_label.dialogue_line = _dialogue_line

	character_label.show()
	dialogue_label.show()
	if not _dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing

	# Wait for input
	if _dialogue_line.responses.size() > 0:
		focus_mode = Control.FOCUS_NONE
		responses_menu.show()
	elif _dialogue_line.time != "":
		var time = _dialogue_line.text.length() * 0.02 if _dialogue_line.time == "auto" else _dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		_next(_dialogue_line.next_id)
	else:
		_is_waiting_for_input = true
		focus_mode = Control.FOCUS_ALL
		grab_focus()


func _next(next_id: String) -> void:
	_is_waiting_for_input = false
	_dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id)


#endregion

#region Mutations


func change_location(next_location: String, is_instant: bool = false) -> void:
	character_label.hide()
	dialogue_label.hide()
	responses_menu.hide()

	location = next_location
	if is_instant:
		_swap_location_texture()
	else:
		animation_player.play(&"change_location")
		await animation_player.animation_finished


# Add a character to the current location.
func add_character(character_name: String, slot_index: int) -> void:
	var slot: Marker2D = slots[slot_index]

	if slot.get_child_count() > 0:
		await remove_character(slot.get_child(0).character_name)

	var character: BasePortrait = load("res://characters/%s/portrait.tscn" % [character_name]).instantiate()
	slot.add_child(character)
	character.global_position.y = 750 * 2

	if slot_index == SLOT_RIGHT:
		character.scale = Vector2(-1, 1)

	var tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(character, "global_position:y", 750, 0.4).from_current()
	await tween.finished

	characters[character_name] = character


# Remove a character from the current location
func remove_character(character_name: String) -> void:
	if not characters.has(character_name): return

	var character: BasePortrait = characters.get(character_name)
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(character, "global_position:y", 750 * 2, 0.3).from_current()
	await tween.finished
	character.get_parent().remove_child(character)
	character.queue_free()

	characters.erase(character_name)


#endregion

#region Callbacks


func _swap_location_texture() -> void:
	for character_name in characters:
		characters.get(character_name).queue_free()
	characters.clear()

	var path: String = "res://locations/%s.png" % [location]
	if ResourceLoader.exists(path):
		location_background.texture = load(path)


#endregion

#region Signals


func _on_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not _is_waiting_for_input: return
	if _dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		_next(_dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == self:
		_next(_dialogue_line.next_id)


func _on_responses_menu_response_selected(response: Variant) -> void:
	_next(response.next_id)


#endregion


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
	#if anim_name == "fade_in":
		#animation_player.play("RESET")
		#DialogueManager.connect("dialogue_ended",restartGame)
