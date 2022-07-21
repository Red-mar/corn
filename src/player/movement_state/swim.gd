extends "res://src/state/state.gd"

var original_gravity = 1
var original_speed = 1

func enter(args):
	original_gravity = owner.gravity_mod
	original_speed = owner.speed_mod
	owner.gravity_mod = 0.6
	owner.speed_mod = 0.9

func exit():
	owner.gravity_mod = original_gravity
	owner.speed_mod = original_speed
	

func update(_delta):
	owner.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	update_state()
	update_animation()

func update_state():
	if not owner.is_in_water():
		emit_signal("finished", "fall")

func update_animation():
	if abs(owner.velocity.x) > owner.MAX_SPEED * 0.7:
		owner.get_node("AnimatedSprite").speed_scale = 1
	if abs(owner.velocity.x) < owner.MAX_SPEED * 0.7:
		owner.get_node("AnimatedSprite").speed_scale = 0.5

	owner.get_node("AnimatedSprite").flip_h = (owner.velocity.x < 0)

func handle_input(event):
	if event.is_action_pressed("jump"):
		owner.velocity.y = -400
	if event.is_action_pressed("punch"):
		emit_signal("finished", "attack")
	.handle_input(event)


func get_input_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_up")
	)
