extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _dialogue = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_dialogue(dialogue):
	_dialogue = dialogue

func end_dialogue():
	get_tree().paused = false
	get_parent().world_ui.show()
	hide()

func _on_Button_pressed():
	end_dialogue()
