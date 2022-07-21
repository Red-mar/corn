extends "res://src/state/state.gd"


func enter(args):
	owner.get_node("AnimatedSprite").play("jump")
	owner.velocity.y = -320
	owner.audio.stream = preload("res://src/player/sounds/jump.ogg")
	owner.audio.play()
	

func update(delta):
	update_animation()
	update_state()

func update_state():
	if get_input_direction().y != 0 and owner.can_climb():
		emit_signal("finished", "climb")
	if owner.velocity.y > 0:
		emit_signal("finished", "fall")
	elif owner.is_on_floor():
		if true:
			emit_signal("finished", "move")
		else:
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
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_up")
	)
