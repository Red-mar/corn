class_name Inventory
extends Resource

# Ideally, I would like to store an array of item resources here, but this is
# not well-supported in Godot 3. Once loaded back, the item resources would lose
# their type information. This is because GDScript does not support typed arrays in Godot 3.
#
# So instead, we use a plain dictionary with strings and numbers. Keys are the
# items' unique ids and values represent the owned amount.
#
# Note that dictionaries preserve their order in GDScript.

export var max_items = 28
var items = []

func _init():
	items.resize(max_items)

func add_item(unique_id: String, amount := 1) -> bool:
	var stackable = Database.get_item_data(unique_id).stackable
	var no_free_space = false
	if not stackable:
		no_free_space = _count() + amount > max_items
	if not stackable and no_free_space:
		print("not stackable full invent")
		return false
	if stackable and no_free_space and not has(unique_id):
		return false

	if stackable and has(unique_id):
		items[get_item_position(unique_id)]["amount"] += amount
	else:
		items[_get_free_position()] = {"unique_id": unique_id, "amount": amount}
	emit_changed()
	return true

func _get_free_position() -> int:
	for i in range(0, max_items):
		if items[i] == null:
			return i
	printerr("ummh you should check this")
	return -1

func has(unique_id: String) -> bool:
	for i in range(0, max_items):
		if items[i] and items[i]["unique_id"] == unique_id:
			return true
	return false
	
func get_item_position(unique_id: String) -> int:
	for i in range(0, max_items):
		if items[i] and items[i]["unique_id"] == unique_id:
			return i
	return -1

func _get_lowest_free_position() -> int:
	var lowest = 0
	for item in items:
		if item["position"] > lowest: lowest = item["position"]
	return lowest

func _count() -> int:
	var amount = 0
	for item in items:
		if item:
			amount += 1
		
	return amount

func get_amount(item_unique_id: String) -> int:
	var amount = 0
	for item in items:
		if item and item["unique_id"] == item_unique_id:
			amount += item["amount"]
	return amount

func get_amount_by_position(position: int) -> int:
	return items[position]["amount"]

func get_position(item_unique_id: String) -> int:
	var i = 0
	for item in items:
		if item and item["unique_id"] == item_unique_id:
			return i 
		i += 1	
	return -1

func get_id(index: int):
	return items[index]["unique_id"]

func remove_item(index: int, amount := -1) -> bool:
	var item = items[index]
	if not item: return false
	if items[index]["amount"] < amount: return false
	if amount == -1:
		items[index]["amount"] = 0
	else:
		items[index]["amount"] -= amount
	if items[index]["amount"] <= 0:
		items[index] = null
	emit_changed()
	return true
