extends Control

signal close()

onready var shop_list = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/shop/ShopList
onready var inventory_list = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/inven/InventoryList

var inventory: Inventory = null setget set_inventory
var shop: ShopData = null setget set_shop
var shop_offers = []

func set_inventory(new_inventory: Inventory) -> void:
	if inventory != new_inventory:
		var err = new_inventory.connect("changed", self, "_update_items_displayed")
		if err:
			printerr(err)
	
	inventory = new_inventory

	_update_items_displayed()

func set_shop(new_shop: ShopData):
	if shop != new_shop:
		var err = new_shop.connect("changed", self, "_update_shop_displayed")
		if err: printerr(err)
	
	shop = new_shop
	
	_update_shop_displayed()

func _update_shop_displayed() -> void:
	shop_list.clear()
	for i in range(0, len(shop.stock)):
		# What to show in inventory section if buys_item is false
		shop_offers.append(shop.stock[i].offer_item.unique_id)
		
		var item = shop.stock[i].item
		shop_list.add_icon_item(item.icon)
		shop_list.set_item_metadata(i, shop.stock[i])
		shop_list.set_item_text(i, item.display_name + " x " + str(shop.stock[i].amount) + " for " + shop.stock[i].offer_item.display_name + " x " + str(shop.stock[i].offer_amount))

func _update_items_displayed() -> void:
	inventory_list.clear()
	for i in range(0, inventory.max_items):
		inventory_list.add_icon_item(preload("res://empty_cell.webp"))
		#set_item_custom_bg_color(i, Color(.5, .5, .5))
	for i in range(0, inventory.max_items):
		var item = inventory.items[i]
		if item:
			if not shop.buys_item and not item["unique_id"] in shop_offers: continue
			var item_data = Database.get_item_data(item["unique_id"])
			inventory_list.set_item_icon(i, item_data.icon)
			inventory_list.set_item_metadata(i, item["unique_id"])
			
			if shop.buys_item:
				inventory_list.set_item_text(i, item_data.display_name + " x " + str(item["amount"]) + " sell for " + str(item_data.value) + " each")
			else: # Don't show value
				inventory_list.set_item_text(i, item_data.display_name + " x " + str(item["amount"]))

func _on_ShopList_item_activated(index):
	var offer = shop_list.get_item_metadata(index)
	if inventory.remove_item(inventory.get_position(offer.offer_item.unique_id), offer.offer_amount):
		inventory.add_item(offer.item.unique_id, offer.amount)

func _on_Button_pressed():
	emit_signal("close")

func _on_InventoryList_item_activated(index):
	var item = Database.get_item_data(inventory_list.get_item_metadata(index))
	if inventory.remove_item(inventory.get_position(item.unique_id), 1):
		inventory.add_item("coin", item.value)
