extends Node

signal state_changed(state)

var current_state = null
var states_map = {}
var active = true

export(NodePath) var start_state

func _ready():
	if not start_state:
		start_state = get_child(0)
	for child in get_children():
		var err = child.connect("finished", self, "_change_state")
		states_map[child.name] = child
		if err:
			printerr(err)
	initialize(start_state)
	
func initialize(initial_state):
	current_state = initial_state
	_change_state(current_state.name)
	
func _unhandled_input(event):
	if not active:
		return
	current_state.handle_input(event)
	
func _physics_process(delta):
	if not active:
		return
	current_state.update(delta)

func _change_state(state, args={}):
	current_state.exit()
	current_state = states_map[state]
	current_state.enter(args)
