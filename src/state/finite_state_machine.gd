extends Node

var current_state_map = {}
var _active = false setget set_active

func _ready():
	set_active(true)

func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)

func add_state(effect: Node, args={}):
	add_child(effect)
