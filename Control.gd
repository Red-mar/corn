extends Control

enum popupIds {
	EXAMINE,
	DROP,
	CONSUME,
	USE,
	TALK,
	CANCEL
}

onready var world_ui = $WorldUI
onready var dialogue_ui = $DialogueUI
onready var quest = $WorldUI/HBoxContainer/Quest/

var current_object
var selected_object
var m
var current_dialog


func spawn_context_menu(pos: Vector2, object):
	current_object = object
	# HACK: for inventory item not cleaning up?
	if is_instance_valid(m) and m:
		m.queue_free()
		

	m = PopupMenu.new()
	add_child(m)

	if current_object is ItemData:
		m.add_item("Use", popupIds.USE)
		m.add_item("Drop", popupIds.DROP)
	if current_object is ItemData and current_object.effect:
		m.add_item("Consume", popupIds.CONSUME)
		
	if current_object is NPC:
		m.add_item("Talk", popupIds.TALK)
		
	if "description" in current_object: 
		m.add_item("Examine", popupIds.EXAMINE)
	m.add_item("Cancel", popupIds.CANCEL)


	m.connect("id_pressed", self, "_id_pressed")
	m.connect("popup_hide", m, "queue_free")

	m.popup(Rect2(pos, m.rect_size))
	
func _id_pressed(index: int):
	if index == popupIds.EXAMINE:
		var p = PopupPanel.new()
		add_child(p)
		var l = Label.new()
		p.add_child(l)
		l.text = current_object.description
		p.popup(Rect2(get_local_mouse_position(), p.rect_size))
		p.connect("popup_hide", p, "queue_free")
	elif index == popupIds.TALK:
		get_tree().paused = true
		world_ui.hide()
		var new_dialog = Dialogic.start('my_timeline')
		current_dialog = new_dialog
		dialogue_ui.show()
		add_child(new_dialog)
		new_dialog.connect("timeline_end", self, "_dialogue_end")

		pass
	elif index == popupIds.DROP:
		owner.spawn_item(
			current_object.unique_id,
			 owner._player.global_position,
			 owner._player.inventory.get_amount_by_position(current_object.position)
			)
		owner._player.inventory.remove_item(current_object.position)
	elif index == popupIds.CONSUME:
		if current_object.consumable:
			owner._player.inventory.remove_item(current_object.position)
		var effect = owner._player._effect_scene.instance()
		effect.unique_effect_id = current_object.effect_id
		owner._player.spell_state.add_child(effect)
	elif index == popupIds.USE:
		if not selected_object:
			selected_object = current_object
			return
		if "use" in current_object:
			current_object.use(selected_object)
		else:
			print("nothing interesting happens")
		selected_object = null
	elif index == popupIds.CANCEL:
		pass
	current_object = null

func _dialogue_end(timeline_name):
	get_tree().paused = false
	world_ui.show()
	dialogue_ui.hide()

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 2:
		var collider = owner.spawn_ray()
		if collider:
			spawn_context_menu(event.position, collider)

func _on_UIInventory_context_menu(item: ItemData, at_position: Vector2):
	spawn_context_menu(at_position, item)

func _on_journal_pressed():
	quest.visible = !quest.visible


func _on_TouchScreenButton2_pressed():
	pass
