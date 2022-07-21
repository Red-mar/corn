extends "res://src/state/state_machine.gd"

func _on_AnimatedSprite_animation_finished():
	current_state._on_animation_finished("anim_name")
