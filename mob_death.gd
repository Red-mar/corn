extends "res://src/state/state.gd"

func enter(args):
	owner.get_node("AnimatedSprite").play("idle")
