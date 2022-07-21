extends Node2D

onready var label = $Label

func _ready():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
