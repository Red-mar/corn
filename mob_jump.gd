extends "res://src/state/state.gd"

func enter(args):
	owner.get_node("AnimatedSprite").play("jump")
	owner.velocity.y = -300

func update(_delta):
	update_animation()
	update_state()

func update_state():
	if owner.velocity.y > 0:
		emit_signal("finished", "fall")
	elif owner.is_on_floor():
		if true:
			emit_signal("finished", "move")
		else:
			emit_signal("finished", "idle")
	
func update_animation():
	owner.get_node("AnimatedSprite").flip_h = !(owner.velocity.x < 0)
