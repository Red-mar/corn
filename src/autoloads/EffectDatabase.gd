extends Node

# Maps unique IDs of items to ItemData instances.
var EFFECTS := {}


func _ready() -> void:
	var effects := _load_effects()
	for effect in effects:
		print(effect)
		EFFECTS[effect.unique_id] = effect


func get_effect_data(unique_id: String) -> EffectData:
	if not unique_id in EFFECTS:
		printerr("Trying to get nonexistent item %s in items database" % unique_id)
		return null
	
	return EFFECTS[unique_id]


static func _load_effects() -> Array:
	var effect_files := []
	var effects_folder := "res://src/resources/effects"

	var directory := Directory.new()
	var can_continue := directory.open(effects_folder) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [effects_folder])
		return effect_files

	var err = directory.list_dir_begin(true, true)
	if err:
		printerr(err)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			effect_files.append(effects_folder.plus_file(file_name))
		file_name = directory.get_next()

	var effect_resources := []
	for path in effect_files:
		effect_resources.append(load(path))

	# Ensure each loaded item has valid data in debug builds.
	if OS.is_debug_build():
		var ids := []
		var bad_effects := []
		for effect in effect_resources:
			if effect.unique_id in ids:
				bad_effects.append(effect)
			else:
				ids.append(effect.unique_id)
		for effect in bad_effects:
			printerr("effect %s has a non-unique ID: %s" % [effect.display_name, effect.unique_id])

	return effect_resources
