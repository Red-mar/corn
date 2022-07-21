extends "res://src/state/state.gd"


func enter(args):
	owner.get_node("AnimatedSprite").play("idle")
	#should_fall()

func update(_delta):
	#owner.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	update_state(owner.direction)
		
func update_state(direction):
	if direction.y > 0 and owner.can_climb_top():
		emit_signal("finished", "climb")
	elif direction.y < 0 and not owner.can_climb_top() and owner.can_climb():
		emit_signal("finished", "climb")
	elif direction.x != 0 and abs(owner.velocity.x) > 0:
		emit_signal("finished", "move")
	
func handle_input(event):
	if event.is_action("move_left"):
		owner.direction.x = -1
		update_state(owner.direction)
	elif event.is_action("move_right"):
		owner.direction.x = 1
		update_state(owner.direction)
	if Input.is_action_pressed("move_down") and event.is_action_pressed("jump"):
		owner.position.y += 1
		emit_signal("finished", "fall")
	elif event.is_action_pressed("jump"):
		emit_signal("finished", "jump")
	elif event.is_action_pressed("pickup"):
		owner.pickup()
	elif event.is_action_pressed("move_up"):
		owner.port()
	elif event.is_action_pressed("attack"):
		emit_signal("finished", "attack")
	.handle_input(event)

func should_fall():
	return
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
