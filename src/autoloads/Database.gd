extends Node

# Maps unique IDs of items to ItemData instances.
var ITEMS := {}
var MOBS := {}
var NPCS := {}
var QUESTS := {}
var EFFECTS := {}
var SHOPS := {}
var SHOP_OFFERS := {}

var folders = {
	"items": "res://src/resources/items",
	"mobs": "res://src/resources/mobs",
	"npcs": "res://src/resources/npcs",
	"quests": "res://src/resources/quests",
	"effects": "res://src/resources/effects",
	"shops": "res://src/resources/shops",
	"shop_offers": "res://src/resources/shop_offers",
}

func _ready() -> void:
	for folder in folders:
		var objects = _load_items(folders[folder])
		match folder:
			"items": ITEMS = objects
			"mobs": MOBS = objects
			"npcs": NPCS = objects
			"quests": QUESTS = objects
			"effects": EFFECTS = objects
			"shops": SHOPS = objects
			"shop_offers": SHOP_OFFERS = objects

func get_item_data(unique_id: String) -> ItemData:
	return ITEMS.get(unique_id)

func get_mob_data(unique_id: String) -> MobData:
	return MOBS.get(unique_id)

func get_npc_data(unique_id: String) -> NPCData:
	return NPCS.get(unique_id)
	
func get_quest_data(unique_id: String) -> QuestData:
	return QUESTS.get(unique_id)

func get_effect_data(unique_id: String) -> EffectData:
	return EFFECTS.get(unique_id)

func get_shop_data(unique_id: String) -> ShopData:
	return SHOPS.get(unique_id)
	
func get_shop_offer_data(unique_id: String) -> ShopOfferData:
	return SHOP_OFFERS.get(unique_id)

static func _load_items(folder: String) -> Dictionary:
	var item_files := []

	var directory := Directory.new()
	var can_continue := directory.open(folder) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [folder])
		return {}

	var err = directory.list_dir_begin(true, true)
	if err:
		printerr(err)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			item_files.append(folder.plus_file(file_name))
		file_name = directory.get_next()

	var item_resources := []
	var item_dict := {}
	for path in item_files:
		item_resources.append(load(path))

	# Ensure each loaded item has valid data in debug builds.
	if OS.is_debug_build():
		var ids := []
		var bad_items := []
		for item in item_resources:
			if item.unique_id in ids:
				bad_items.append(item)
			else:
				ids.append(item.unique_id)
				item_dict[item.unique_id] = item
		for item in bad_items:
			printerr("Item %s has a non-unique ID: %s" % [item.display_name, item.unique_id])

	return item_dict
