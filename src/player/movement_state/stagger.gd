extends "res://src/State/state.gd"

const STAGGER_TIME = 1
const INVINCIBILITY_TIME = 2

onready var stagger_timer = owner.get_node("StaggerTimer")
onready var invincibility_timer = owner.get_node("invincibilityTimer")

func enter(args):
	owner.invincibility = true
	owner.get_node("AnimatedSprite").play("jump")
	stagger_timer.start(STAGGER_TIME)
	invincibility_timer.start(INVINCIBILITY_TIME)
	owner.get_node("AnimationPlayer").play("invincible")
	owner.set_collision_mask_bit(2, false)

func _on_StaggerTimer_timeout():
	if owner.state == "dead":
		return
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	else:
		emit_signal("finished", "fall")
