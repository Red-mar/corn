extends "res://src/state/state.gd"

func enter(_args):
	# use frames length
	var frame = randi()%7+1
	owner.get_node("AnimatedSprite").play("walk")
	owner.get_node("AnimatedSprite").frame = frame
	
func update(_delta):
	owner.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if owner.direction.x > 0: owner.direction.x = 1
	elif owner.direction.x < 0: owner.direction.x = -1
	
	update_animation()
	update_state(owner.direction)

func update_state(direction):
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
	elif direction.y > 0 and owner.can_climb_top():
		emit_signal("finished", "climb")
	elif direction.y < 0 and not owner.can_climb_top() and owner.can_climb():
		emit_signal("finished", "climb")
	elif abs(owner.velocity.x) < owner.stats.run_speed * 0.1:
		emit_signal("finished", "idle")
	
		
func update_animation():
	owner.get_node("AnimatedSprite").flip_h = !(owner.velocity.x < 0)
	
func handle_input(event):
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

