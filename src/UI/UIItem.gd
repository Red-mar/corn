class_name UIItem
extends Panel

signal tooltip_requested
signal drop_requested(item_unqiue_id)
signal context_menu(item_unique_id, event)

var item_unique_id := ""

onready var texture_rect := $MarginContainer/HBoxContainer/TextureRect
onready var name_label := $MarginContainer/HBoxContainer/NameLabel
onready var amount_label := $MarginContainer/HBoxContainer/AmountLabel
onready var tooltip_timer := $TooltipTimer


func _ready():
	var err = tooltip_timer.connect("timeout", self, "_request_tooltip")
	#err = connect("mouse_entered", tooltip_timer, "start")
	err = connect("mouse_exited", tooltip_timer, "stop")
	err = connect("gui_input", self, "_input")
	if err:
		printerr(err)

func _input(event: InputEvent):

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT and get_global_rect().has_point(event.position):
		emit_signal("context_menu", item_unique_id, event)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT and get_global_rect().has_point(event.position):
		#var p = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("player")
		#p.stats.health += 10
		#p.inventory.remove_item(item_unique_id)
		pass

func display_item(unique_id: String, amount: int) -> void:
	item_unique_id = unique_id
	
	var data := Database.get_item_data(unique_id)
	texture_rect.texture = data.icon
	name_label.text = data.display_name
	amount_label.text = str(amount).pad_zeros(2)

func _request_tooltip() -> void:
	if item_unique_id:
		emit_signal("tooltip_requested")
