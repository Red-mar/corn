extends Control


onready var option_list = $PopupMenu/PanelContainer/OptionList
onready var menu = $PopupMenu

var options = []

# Called when the node enters the scene tree for the first time.
func _ready():
	menu.add_item("Cancel")
	pass

func get_context_menu_result():
	menu.popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
