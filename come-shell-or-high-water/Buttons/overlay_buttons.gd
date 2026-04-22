extends Control

var ev = InputEventAction.new()

func _ready() -> void:
	Input.action_release("ui_right")
	ev.pressed = false
	#DialogueManager.connect("dialogue_started",hideButtons)
	#DialogueManager.connect("dialogue_ended",showButtons)
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		show()
		DialogueManager.connect("dialogue_started",hideButtons)
		DialogueManager.connect("dialogue_ended",showButtons)
	
func hideButtons(resource):
	release_buttons()
	ev.pressed = false
	hide()
	
	
func showButtons(resource):
	release_buttons()
	ev.pressed = false
	show()
	
func _process(delta: float) -> void:
	if(Input.is_action_just_released("ui_right")):
		ev.pressed = false
	#if(Input.is_action_just_released("ui_left")):
		#ev.pressed = false
	#if(Input.is_action_just_released("ui_up")):
		#ev.pressed = false
	#if(Input.is_action_just_released("ui_down")):
		#ev.pressed = false
	#print(Input.is_anything_pressed())

func _on_down_button_pressed() -> void:
	#print("pressed_down")
	#var ev = InputEventAction.new()
	# Set as ui_left, pressed.
	ev.action = "ui_down"
	ev.pressed = true
	# Feedback.
	Input.parse_input_event(ev)

func _on_up_button_pressed() -> void:
	#print("pressed_up")
	#var ev = InputEventAction.new()
	# Set as ui_left, pressed.
	ev.action = "ui_up"
	ev.pressed = true
	# Feedback.
	Input.parse_input_event(ev)

func _on_left_button_pressed() -> void:
	#print("pressed_left")
	# Set as ui_left, pressed.
	ev.action = "ui_left"
	ev.pressed = true
	# Feedback.
	Input.parse_input_event(ev)

func _on_right_button_pressed() -> void:
	#print("pressed_right")
	# Set as ui_left, pressed.
	ev.action = "ui_right"
	ev.pressed = true
	# Feedback.
	Input.parse_input_event(ev)

func _on_down_button_button_up() -> void:
	Input.action_release("ui_down")
	ev.pressed = false

func _on_up_button_button_up() -> void:
	Input.action_release("ui_up")
	ev.pressed = false

func _on_left_button_button_up() -> void:
	Input.action_release("ui_left")
	ev.pressed = false

func _on_right_button_button_up() -> void:
	Input.action_release("ui_right")
	ev.pressed = false

func release_buttons():
	Input.action_release("ui_up")
	Input.action_release("ui_down")
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	ev.pressed = false
