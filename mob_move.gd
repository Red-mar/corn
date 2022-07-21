extends "res://src/state/state.gd"

var last_position = Vector2.ZERO

func enter(_args):
	# use frames length
	var frame = 2
	owner.get_node("AnimatedSprite").play("move")
	owner.get_node("AnimatedSprite").frame = frame
	
func update(_delta):
	update_animation()
	update_state(owner.direction)
	last_position = owner.position

func update_state(direction):
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
	elif abs(owner.velocity.x) < owner.stats.run_speed * 0.1:
		emit_signal("finished", "idle")
	elif owner.position == last_position:
		emit_signal("finished", "jump")
		
func update_animation():
	owner.get_node("AnimatedSprite").flip_h = !(owner.velocity.x < 0)
