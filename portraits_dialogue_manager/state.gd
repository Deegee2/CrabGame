extends Node


signal some_signal()


var apple_status: String = ""


func _ready() -> void:
	some_signal.connect(func(): prints("HELLO"))
