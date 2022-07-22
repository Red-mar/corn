extends "res://src/state/state.gd"
var _effect_scene = load("res://effect.tscn")

export var unique_effect_id := "damage"
var caster

var effect_data
var display_name := ""
var description := ""

var _duration: float
var _interval: float
var elapsed := 0.0

var _health: int
var _variability: int
var _strength_scaling: int

var target = null

onready var _timer = $EffectTimer

func _ready():
	target = get_parent()
	effect_data = Database.get_effect_data(unique_effect_id)
	display_name = effect_data.display_name
	description = effect_data.description
	
	_duration = effect_data.duration
	_interval = effect_data.interval
	
	_variability = effect_data.variability
	_strength_scaling = effect_data.strength_scaling
	
	if effect_data.particles:
		var p = effect_data.particles.instance()
		target.add_child(p)
		p.timer.stop()
		p.timer.wait_time = _duration
		p.timer.start()
		
	
	_health = effect_data.health

	if _duration == 0 or _interval == 0:
		_apply_effect()
		_end()
		queue_free()
		return
	_apply_effect(_duration, _interval)
	_timer.start(_interval)
	
func _apply_effect(duration = 1, interval = 1):
	
	var eff = 0
	if _health:
		var value_range = randi()%_variability
		var scaling = 1
		if "stats" in caster:
			scaling = caster.stats.strength * _strength_scaling
		eff = ((_health - value_range) - scaling) / (duration / interval)
	
	if eff:
		target.stats.health += eff
		target.di(eff)
	if target.stats.health > target.stats.max_health:
		target.stats.health = target.stats.max_health
	if target.stats.health <= 0:
		target.kill()
	
	if effect_data.drop_item:
		target.drop_item(effect_data.drop_item)

func _on_EffectTimer_timeout():
	elapsed += _interval
	if elapsed >= _duration:
		_timer.stop()
		_end()
		queue_free()
		return
	_apply_effect(_duration, _interval)
	
func _end():
	target.scale = target.original_scale
	
	if effect_data.chain_effect:
		target.add_effect(effect_data.chain_effect, caster)
	target.remove_effect(unique_effect_id)
