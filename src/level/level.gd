extends Node2D

enum CLIMABLE {
	TILE_ROPE_TOP = 0,
	TILE_ROPE_MIDDLE_1 = 1,
	TILE_ROPE_MIDDLE_2 = 2,
	TILE_ROPE_BOTTOM = 3,
}

enum CLIMABLE_TOP {
	TILE_ROPE_TOP = 0,
}

onready var objects = $object_map
onready var level_area = $map

export var bounds: Rect2 = Rect2()
export var bounds_left = -650
export var bounds_right = 1500

func _ready():
	pass

func is_climable(world_position: Vector2):
	var obje = objects.world_to_map(world_position)
	var mid = (obje.x * 50) + 26
	var i = objects.get_cellv(objects.world_to_map(world_position))
	if i in CLIMABLE.values():
		 return mid
	else:
		return false
		
func is_climable_top(world_position: Vector2):
	var obje = objects.world_to_map(world_position)
	var mid = (obje.x * 50) + 26
	var i = objects.get_cellv(objects.world_to_map(world_position))
	if i in CLIMABLE_TOP.values():
		 return mid
	else:
		return false
