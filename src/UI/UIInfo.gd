extends PanelContainer

var character: Character setget set_character

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _player_position_label = $MarginContainer/VBoxContainer/Position as Label
onready var _player_velocity_label = $MarginContainer/VBoxContainer/Velocity as Label
onready var _player_state_label = $MarginContainer/VBoxContainer/State as Label
onready var _player_health_label = $MarginContainer/VBoxContainer/Health as Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_position_label(position: Vector2) -> void:
	_player_position_label.text = "Position: " + str(position.round())
	
func update_velocity_label(velocity: Vector2) -> void:
	_player_velocity_label.text = "Velocity: " + str(velocity.round())
	
func update_state_label(state: String) -> void:
	_player_state_label.text = "State: " + state
	
func update_health_label(health: int, max_health: int) -> void:
	_player_health_label.text = "Health: " + str(health) + " / " + str(max_health)

func set_character(new_character) -> void:
	character = new_character
	
