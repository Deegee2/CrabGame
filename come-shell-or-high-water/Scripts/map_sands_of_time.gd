extends Control

func add_characters(character_name):
	GlobalVariables.characters_in_scene.append(character_name)

func print_characters():
	print(GlobalVariables.characters_in_scene)

func erase_characters():
	GlobalVariables.characters_in_scene.clear()
