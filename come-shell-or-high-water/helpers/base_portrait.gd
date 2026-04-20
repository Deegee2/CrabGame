class_name BasePortrait extends Node


@export var animation_player: AnimationPlayer


func emote(tags: Array) -> void:
	pass
	#if not is_instance_valid(animation_player): return
#
	#for tag in tags:
		#if animation_player.has_animation(tag):
			#animation_player.play(tag)
