extends "res://src/state/state.gd"

const CLIMB_SPEED = 100
var velocity = 0

func enter(_args):
	owner.set_collision_mask_bit(0, false)
	owner.velocity = Vector2.ZERO
	owner.get_node("AnimatedSprite").play("climb")
	owner.animated_sprite.flip_h = 1
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.y > 0:
		owner.position.y += 10
	
	owner.fix_climb_pos()

func update(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if !direction:
		owner.get_node("AnimatedSprite").stop()
	elif not owner.get_node("AnimatedSprite").playing:
		owner.get_node("AnimatedSprite").play("climb")
	velocity =  direction.y * CLIMB_SPEED * delta
	owner.position.y += velocity
	update_state()
		
func update_state():
	if not owner.can_climb():
		emit_signal("finished", "fall")
	if velocity < 0 and owner.can_climb_top():
		emit_signal("finished", "idle")

func handle_input(event):
	if event.is_action_pressed("jump"):
		owner.direction.x = Input.get_vector("move_left", "move_right", "move_up", "move_down").x
		emit_signal("finished", "jump")
	.handle_input(event)
	
func exit():
	owner.set_collision_mask_bit(0, true)
