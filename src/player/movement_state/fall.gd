extends "res://src/state/state.gd"

func enter(args):
	owner.get_node("AnimatedSprite").play("jump")

func update(delta):
	update_animation()
	update_state()
	
func update_state():
	# Cannot climb from falling at the top
	if get_input_direction().y > 0 and not owner.can_climb_top() and owner.can_climb():
		emit_signal("finished", "climb")
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	#if owner.is_in_water():
	#	emit_signal("finished", "swim")

func update_animation():
	owner.get_node("AnimatedSprite").flip_h = !(owner.velocity.x < 0)

func handle_input(event):
	if event.is_action_pressed("attack"):
		emit_signal("finished", "attack")
	.handle_input(event)

func get_input_direction():
	return Vector2(
		0,
		Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	)
