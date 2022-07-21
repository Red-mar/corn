extends "res://src/state/state.gd"


func enter(args):
	owner.get_node("AnimatedSprite").play("idle")

func update(_delta):
	update_state(owner.direction)
		
func update_state(direction):
	if direction.x != 0:
		emit_signal("finished", "move")

func should_fall():
	return
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
