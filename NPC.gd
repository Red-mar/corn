class_name NPC
extends WorldCharacter

export var unique_id := ""
var display_name: String = ""

onready var _anim = $AnimationPlayer
onready var _sprite = $AnimatedSprite
onready var _timer = $Timer
onready var _hitbox = $hitbox
onready var _col = $CollisionShape2D
onready var _label = $Label

var original_scale = scale

var loot_table = ["coin", "icon"]

func _ready():
	var npc_data = NpcDatabase.get_npc_data(unique_id)
	_sprite.frames = npc_data.animation
	display_name = npc_data.display_name
	description = npc_data.description
	_label.text = display_name
	_anim.play("spawn")

	_timer.connect("timeout", self, "_blink")
	_timer.start()

func _blink():
	_timer.wait_time = 1
	_timer.disconnect("timeout", self, "_blink")
	_timer.connect("timeout", self, "_idle")
	_timer.start()
	_sprite.play("blink")
	
func _idle():
	_timer.wait_time = randi()%3+1
	_timer.disconnect("timeout", self, "_idle")
	_timer.connect("timeout", self, "_blink")
	_timer.start()
	_sprite.play("idle")
	

func damage(effect_id = "damage", from = Vector2.ZERO):
	$movement_state._change_state("stagger", {"from": from})
	add_effect(effect_id)
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
	get_parent().get_parent().get_parent().spawn_item(loot_table[loot], global_position)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		var loot = randi() % 2
		drop_item(loot)
	
		queue_free()


func _on_NPC_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == 1:
		print("?")


func _on_NPC_mouse_entered():
	_label.visible = true


func _on_NPC_mouse_exited():
	_label.visible = false
