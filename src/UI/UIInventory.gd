extends ItemList

signal context_menu(unique_id, event)

const UIItemScene := preload("res://src/UI/UIItem.tscn")

var inventory: Inventory = null setget set_inventory
var grabbed_item = null
var grabbed_icon = null

func set_inventory(new_inventory: Inventory) -> void:
	if inventory != new_inventory:
		var err = new_inventory.connect("changed", self, "_update_items_displayed")
		if err:
			printerr(err)
	
	inventory = new_inventory

	_update_items_displayed()

func _update_items_displayed() -> void:
	clear()
	for i in range(0, inventory.max_items):
		add_icon_item(preload("res://empty_cell.webp"))
		#set_item_custom_bg_color(i, Color(.5, .5, .5))
	for i in range(0, inventory.max_items):
		var item = inventory.items[i]
		if item:
			var item_data = Database.get_item_data(item["unique_id"])
			set_item_icon(i, item_data.icon)
			set_item_metadata(i, item["unique_id"])
			if item["amount"] > 1:
				set_item_text(i, str(item["amount"]))

func _swap_item(from: int, to: int):
	var item_from = inventory.items[from]
	var item_to = inventory.items[to]
	inventory.items[to] = item_from
	inventory.items[from] = item_to
	_update_items_displayed()

func _on_ItemList_item_rmb_selected(index, at_position):
	if inventory.items[index] == null: return
	var item = Database.get_item_data(inventory.items[index]["unique_id"])
	item.position = index
	emit_signal("context_menu", item, get_global_mouse_position())

func _grab(position: Vector2):
	grabbed_item = get_item_at_position(position)
	grabbed_icon = Sprite.new()
	grabbed_icon.texture = get_item_icon(grabbed_item)
	grabbed_icon.scale = Vector2(.5, .5)
	grabbed_icon.modulate = Color(1, 1, 1, .6)
	get_parent().add_child(grabbed_icon)
	grabbed_icon.z_index = 1
	grabbed_icon.global_position = get_global_mouse_position()

func _release(position: Vector2):
	if not grabbed_icon: return
	grabbed_icon.queue_free()
	grabbed_icon = null
	if get_rect().has_point(position):
		var target = get_item_at_position(position)
		_swap_item(grabbed_item, target)
	else:
		owner.add_item_effect_to_collider(grabbed_item)

func _on_ItemList_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		_grab(event.position)
	elif event is InputEventMouseButton and not event.is_pressed() and event.button_index == BUTTON_LEFT:
		_release(event.position)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT and grabbed_icon:
		# DROP ITEM
		if get_item_metadata(grabbed_item):
			owner.spawn_item(
				get_item_metadata(grabbed_item),
				owner._player.global_position,
				owner._player.inventory.get_amount_by_position(grabbed_item)
				)
			owner._player.inventory.remove_item(grabbed_item)
			grabbed_icon.queue_free()
			grabbed_icon = null
	elif event is InputEventMouse:
		if grabbed_icon: grabbed_icon.global_position = event.global_position
		if grabbed_icon and owner.can_use_item(grabbed_item):
			grabbed_icon.modulate = Color(1, 1, 1, 1)
		elif grabbed_icon:
			grabbed_icon.modulate = Color(1, 1, 1, .6)

func _on_ItemList_item_selected(index):
	pass # Replace with function body.


func _on_UIInventory_item_activated(index):
	pass # Replace with function body.
