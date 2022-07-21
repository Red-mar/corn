class_name WorldCharacter
extends KinematicBody2D

var description = ""

var stats: Character = Character.new()

const KNOCKBACK := Vector2(500, -500)
const DRAG_FACTOR := 0.15

onready var GRAVITY = 14
var _effect_scene = preload("res://effect.tscn")
var _di_scene = preload("res://DamageIndicatorLabel.tscn").instance()
var _slash_scene = preload("res://slashfx.tscn")

var effects = {}

var velocity = Vector2.ZERO
var direction = Vector2.ZERO

func base_physics(delta):
	var desired_velocity = direction.x * stats.run_speed

	var steering = desired_velocity - velocity.x
	velocity.x += steering * DRAG_FACTOR
	
	velocity.y += GRAVITY
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true, 4, 1.1)
			
func stagger() -> void:
	pass

func add_effect(effect_id: String):
	if effects.has(effect_id):
		effects[effect_id] += 1
	else:
		effects[effect_id] = 1

	var effect = _effect_scene.instance()
	effect.unique_effect_id = effect_id
	add_child(effect)
	
func remove_effect(effect_id: String):
	effects[effect_id] -= 1
	if effects[effect_id] <= 0:
		effects.erase(effect_id)

func kill() -> void:
	pass

func di(value):
	var di_d = _di_scene.duplicate()
	get_parent().get_parent().add_child(di_d)
	di_d.position = position + Vector2(0, -50)
	di_d.label.text = str(value)
	if value > 0:
		di_d.label.self_modulate = Color(0, 1, 0, 1)
	else:
		var sc = _slash_scene.instance()
		sc.frame = 0
		add_child(sc)
		di_d.label.self_modulate = Color(1, 0, 0, 1)
		$AudioStreamPlayer2D.stream = preload("res://src/player/sounds/explosion.ogg")
		$AudioStreamPlayer2D.play()

func set_stats(new_stats: Character) -> void:
	stats = new_stats
	set_physics_process(stats != null)
