extends PanelContainer

var character: Character setget set_character

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _player_strength_label = $MarginContainer/VBoxContainer/Strength as Label
onready var _player_intellect_label = $MarginContainer/VBoxContainer/Intellect as Label
onready var _player_dexterity_label = $MarginContainer/VBoxContainer/Dexterity as Label
onready var _player_renown_label = $MarginContainer/VBoxContainer/Renown as Label
onready var _player_state_label = $MarginContainer/VBoxContainer/State as Label
onready var _player_health_label = $MarginContainer/VBoxContainer/Health as Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_strength_label(strength: int) -> void:
	_player_strength_label.text = "Strength: " + str(strength)
	
func update_intellect_label(intellect: int) -> void:
	_player_intellect_label.text = "Intellect: " + str(intellect)
	
func update_dexterity_label(dexterity: int) -> void:
	_player_dexterity_label.text = "Dexterity: " + str(dexterity)
	
func update_renown_label(renown: int) -> void:
	_player_renown_label.text = "Renown: " + str(renown)
	
func update_state_label(state: String) -> void:
	_player_state_label.text = "State: " + state
	
func update_health_label(health: int, max_health: int) -> void:
	_player_health_label.text = "Health: " + str(health) + " / " + str(max_health)

func set_character(new_character) -> void:
	character = new_character
	
