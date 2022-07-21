extends "res://src/state/state.gd"

var shotted = false
var held = true

func enter(args):
	shotted = false
	held = true
	if owner.animated_sprite.frame == 3:
		owner.animated_sprite.frame = 0
	
	owner.animated_sprite.play("attack")


func update(_delta):

	if not shotted and owner.animated_sprite.frame == 3:
		owner.shoot()
		shotted = true

	
func handle_input(event):
	if event.is_action_pressed("attack"):
		emit_signal("finished", "attack")
	if event.is_action_released("attack"):
		held = false
	.handle_input(event)

func should_fall():
	return
	if not owner.is_on_floor():
		emit_signal("finished", "fall")

func _on_animation_finished(anim):
	if held:
		emit_signal("finished", "attack")
	elif not owner.is_on_floor():
		emit_signal("finished", "fall")
	elif abs(owner.velocity.x) < owner.stats.run_speed * 0.1:
		emit_signal("finished", "idle")
	else:
		emit_signal("finished", "move")
