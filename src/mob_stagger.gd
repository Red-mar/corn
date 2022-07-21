extends "res://src/state/state.gd"

const STAGGER_TIME = .4

onready var stagger_timer = $stagger_timer

var old_direction = Vector2.ZERO

func enter(args):
	old_direction = owner.direction
	owner.direction = Vector2.ZERO
	var dir = args["from"].x > owner.global_position.x
	owner._sprite.play("idle")
	if dir: owner.velocity.x = -200
	else: owner.velocity.x = 200

	owner.get_node("AnimationPlayer").play("stagger")
	stagger_timer.start(STAGGER_TIME)

func update(_delta):
	pass
	#if owner._sprite.flip_h: owner.velocity.x = -200
	#else: owner.velocity.x = 200

func exit():
	owner.direction = old_direction


func _on_stagger_timer_timeout():
	if owner._anim.current_animation == "stagger":
		owner.get_node("AnimationPlayer").stop()
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	else:
		emit_signal("finished", "fall")
