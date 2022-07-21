extends "res://src/state/state.gd"

const STAGGER_TIME = 1

onready var stagger_timer = $stagger_timer

func enter(args):
	owner.animated_sprite.play("jump")
	owner.velocity.y = -200
	stagger_timer.start()

func update(_delta):
	if owner.animated_sprite.flip_h: owner.velocity.x = -200
	else: owner.velocity.x = 200

func exit():
	pass


func _on_stagger_timer_timeout():
	owner.velocity.x = 0
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	else:
		emit_signal("finished", "fall")
