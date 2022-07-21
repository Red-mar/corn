extends Control

var _di_label = preload("res://DamageIndicatorLabel.tscn")

func _damage(value):
	var di = _di_label.instance()
	add_child(di)
	di.label.text = str(value)

