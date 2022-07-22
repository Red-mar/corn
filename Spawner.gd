extends Position2D

export var MAX_SPAWNS = 4
export var unique_mob_id = ""

var _mob: Mob
var _mob_scene = preload("res://Mob.tscn")

onready var timer = $SpawnTimer
onready var cast = $RayCast2D

func _ready():
	timer.start()

func _on_SpawnTimer_timeout():
	if not get_child_count() > MAX_SPAWNS:
		_mob = _mob_scene.instance()
		_mob.unique_id = unique_mob_id
		owner.add_child(_mob)
		_mob.global_position = cast.get_collision_point() - (_mob._col.shape.extents + Vector2(0, -10) / 2) + Vector2(randi()%200, 0)

	timer.start(rand_range(10, 40))
