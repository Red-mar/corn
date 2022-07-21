extends "res://src/state/state.gd"

func enter(args):
	
	emit_signal("finished", "pickup")
