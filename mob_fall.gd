extends "res://src/state/state.gd"

func enter(args):
	owner.get_node("AnimatedSprite").play("jump")

func update(delta):
	update_animation()
	update_state()
	
func update_state():
	if owner.is_on_floor():
		emit_signal("finished", "idle")

func update_animation():
	owner.get_node("AnimatedSprite").flip_h = !(owner.velocity.x < 0)
