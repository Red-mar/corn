extends Node

# Maps unique IDs of items to ItemData instances.
var MOBS := {}


func _ready() -> void:
	var mobs := _load_mobs()
	for mob in mobs:
		MOBS[mob.unique_id] = mob


func get_mob_data(unique_id: String) -> MobData:
	if not unique_id in MOBS:
		printerr("Trying to get nonexistent item %s in items database" % unique_id)
		return null
	
	return MOBS[unique_id]


static func _load_mobs() -> Array:
	var mob_files := []
	var mobs_folder := "res://src/resources/mobs"

	var directory := Directory.new()
	var can_continue := directory.open(mobs_folder) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [mobs_folder])
		return mob_files

	var err = directory.list_dir_begin(true, true)
	if err:
		printerr(err)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			mob_files.append(mobs_folder.plus_file(file_name))
		file_name = directory.get_next()

	var mob_resources := []
	for path in mob_files:
		mob_resources.append(load(path))

	# Ensure each loaded item has valid data in debug builds.
	if OS.is_debug_build():
		var ids := []
		var bad_mobs := []
		for mob in mob_resources:
			if mob.unique_id in ids:
				bad_mobs.append(mob)
			else:
				ids.append(mob.unique_id)
		for mob in bad_mobs:
			printerr("Mob %s has a non-unique ID: %s" % [mob.display_name, mob.unique_id])

	return mob_resources
