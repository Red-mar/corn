extends "res://src/State/state.gd"

func enter(_args):
	owner.velocity = Vector2()
	owner.visible = false
	
func handle_input(event):
	pass
	
func exit():
	owner.visible = true
