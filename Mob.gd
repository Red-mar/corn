class_name Mob
extends WorldCharacter

export var unique_id := ""
var display_name: String = ""

onready var _anim = $AnimationPlayer
onready var _sprite = $AnimatedSprite
onready var _timer = $Timer
onready var _hitbox = $hitbox
onready var _col = $CollisionShape2D

var original_scale = scale

var loot_table = ["coin", "coin", "coin", "potion"]

func _ready():
	_hitbox.collision_mask = 0
	_hitbox.collision_layer = 0
	collision_layer = 0
	var mob_data = Database.get_mob_data(unique_id)
	stats = mob_data.stats.duplicate()
	_sprite.frames = mob_data.animation
	display_name = mob_data.display_name
	description = mob_data.description
	_anim.play("spawn")
	_timer.connect("timeout", self, "_change_direction")
	_timer.start()

func _change_direction():
	direction = Vector2(randi()%3-1, 0)

func damage(effect_id, from):
	$movement_state._change_state("stagger", {"from": from.position})
	add_effect(effect_id, from)
	print(stats.health)
	if stats.health == 0:
		kill()

func kill():
	$movement_state._change_state("death")
	collision_layer = 0
	_hitbox.collision_mask = 0
	_anim.play("death")
	_timer.stop()
	direction = Vector2.ZERO

func _physics_process(delta):
	base_physics(delta)


func _on_hitbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		body.stagger()

func drop_item(loot):
	get_parent().get_parent().spawn_item(loot, global_position, 1)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		var loot = randi() % 4
		drop_item(loot_table[loot])
		queue_free()
		
		return
	elif anim_name == "spawn":
		_hitbox.set_collision_mask_bit(0, true)
		_hitbox.set_collision_layer_bit(4, true)
		set_collision_layer_bit(4, true)
