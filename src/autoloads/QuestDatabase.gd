extends Node

# Maps unique IDs of items to ItemData instances.
var QUESTS := {}


func _ready() -> void:
	var quests := _load_quests()
	for quest in quests:
		QUESTS[quest.unique_id] = quest


func get_quest_data(unique_id: String) -> QuestData:
	if not unique_id in QUESTS:
		printerr("Trying to get nonexistent item %s in items database" % unique_id)
		return null
	
	return QUESTS[unique_id]

static func _load_quests() -> Array:
	var quest_files := []
	var quests_folder := "res://src/resources/quests"

	var directory := Directory.new()
	var can_continue := directory.open(quests_folder) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [quests_folder])
		return quest_files

	var err = directory.list_dir_begin(true, true)
	if err:
		printerr(err)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			quest_files.append(quests_folder.plus_file(file_name))
		file_name = directory.get_next()

	var quest_resources := []
	for path in quest_files:
		quest_resources.append(load(path))

	# Ensure each loaded item has valid data in debug builds.
	if OS.is_debug_build():
		var ids := []
		var bad_quests := []
		for quest in quest_resources:
			if quest.unique_id in ids:
				bad_quests.append(quest)
			else:
				ids.append(quest.unique_id)
		for quest in bad_quests:
			printerr("quest %s has a non-unique ID: %s" % [quest.display_name, quest.unique_id])

	return quest_resources
