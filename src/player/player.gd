class_name Player
extends WorldCharacter

signal port_request(dest)

const unique_id = ""

onready var inventory: Inventory = Inventory.new()

onready var state = $movement_state

onready var object_area = $object_area
onready var animated_sprite = $AnimatedSprite
onready var invincibility_timer = $invincibility_timer
onready var animation = $AnimationPlayer
onready var camera = $Camera2D
onready var audio = $AudioStreamPlayer2D

var invincible = false
var original_scale = scale

### climibng
onready var area = owner.get_node("level")
func fix_climb_pos() -> void:
	var climb_pos = area.is_climable(position)
	if not climb_pos:
		climb_pos = area.is_climable_top(position)
	if not climb_pos:
		 climb_pos = area.is_climable_top(extended_position())
	if not climb_pos:
		print("??")
		return
	position.x = climb_pos

func can_climb():
	return area.is_climable(position - Vector2(0, 20)) or area.is_climable_top(extended_position())
func can_climb_top():
	return area.is_climable_top(position - Vector2(0, 20)) or area.is_climable_top(extended_position())
# Lower right of the collision shape
func extended_position():
	return position - $CollisionShape2D.shape.extents
###

func _physics_process(delta):
	if state.current_state.name == "climb":
		return
	if state.current_state.name == "attack" and is_on_floor():
		direction.x = 0
	base_physics(delta)

func pickup() -> void:
	var items = object_area.get_overlapping_bodies()
	for item in items:
		if item is WorldItem:
			if inventory.add_item(item.unique_id, item.amount):
				item.pickup()
				$AudioStreamPlayer2D.stream = preload("res://src/player/sounds/pickupCoin.ogg")
				$AudioStreamPlayer2D.play()
				break

func port():
	var areas = object_area.get_overlapping_areas()
	for area in areas:
		if area is Port:
			owner.port_player(Vector2(area.dest.global_position.x, area.dest.global_position.y))
		if area is LevelPort:
			owner.port_player(area.destination, area.destination_position)

func stagger() -> void:
	if invincible: return
	invincible = true
	invincibility_timer.start()
	
	add_effect("damage")
	
	state._change_state("stagger")
	animation.play("stagger")

func kill() -> void:
	print("ded")

func shoot() -> void:
	var dir = int(animated_sprite.flip_h)
	if dir == 0:
		dir = -1
	owner.spawn_object("bullet", position + (Vector2(25 * dir, -30)), dir)

func _on_invincibility_timer_timeout():
	animation.stop()
	invincible = false
