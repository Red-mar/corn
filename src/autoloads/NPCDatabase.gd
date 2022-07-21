extends Node

# Maps unique IDs of items to ItemData instances.
var NPCS := {}


func _ready() -> void:
	var npcs := _load_npcs()
	for npc in npcs:
		NPCS[npc.unique_id] = npc


func get_npc_data(unique_id: String) -> NPCData:
	if not unique_id in NPCS:
		printerr("Trying to get nonexistent item %s in items database" % unique_id)
		return null
	
	return NPCS[unique_id]


static func _load_npcs() -> Array:
	var npc_files := []
	var npcs_folder := "res://src/resources/npcs"

	var directory := Directory.new()
	var can_continue := directory.open(npcs_folder) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [npcs_folder])
		return npc_files

	var err = directory.list_dir_begin(true, true)
	if err:
		printerr(err)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			npc_files.append(npcs_folder.plus_file(file_name))
		file_name = directory.get_next()

	var npc_resources := []
	for path in npc_files:
		npc_resources.append(load(path))

	# Ensure each loaded item has valid data in debug builds.
	if OS.is_debug_build():
		var ids := []
		var bad_npcs := []
		for npc in npc_resources:
			if npc.unique_id in ids:
				bad_npcs.append(npc)
			else:
				ids.append(npc.unique_id)
		for npc in bad_npcs:
			printerr("npc %s has a non-unique ID: %s" % [npc.display_name, npc.unique_id])

	return npc_resources
