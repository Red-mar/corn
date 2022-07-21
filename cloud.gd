extends Node2D

export var speed := .06

onready var _animation_player := $AnimationPlayer

func _ready():
	_animation_player.playback_speed = speed
