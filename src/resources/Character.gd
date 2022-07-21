class_name Character
extends Resource

export var display_name := "Godot"
export var run_speed := 200.0

export var level := 1
export var experience := 0

var renown = 0

export var max_strength := 5
var strength = max_strength

export var max_dexterity := 5
var dexterity = max_dexterity

export var max_intellect := 5
var intellect = max_intellect

export var max_stamina := 5
var stamina = max_stamina

var max_health = stamina * 10
var health: float = max_health

var mana = intellect * 10
