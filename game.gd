extends Node

onready var _player := $player
onready var _ui := $UI/Control
onready var _ui_info := $UI/Control/WorldUI/HBoxContainer/Info
onready var _inventory := $UI/Control/WorldUI/HBoxContainer/Inventory
onready var _ui_inventory := $UI/Control/WorldUI/HBoxContainer/Inventory/UIInventory
onready var _level := $level
onready var _context_cast := $ContextCast

var _world_item = preload("res://src/resources/WorldItem.tscn")
var _rng = RandomNumberGenerator.new()

var _bullet = preload("res://bullet.tscn")
var quests = {}

var current_target

func _ready():
	# TODO load from save if available
	quests = Database.QUESTS.duplicate(true)
	
	_ui_inventory.set_inventory(_player.inventory)
	_rng.randomize()

func spawn_item(item_id: String, position: Vector2, amount: int) -> void:
	var item = Database.get_item_data(item_id)
	var world_item = _world_item.instance()
	if item.stackable:
		world_item.amount = amount
	world_item.unique_id = item_id
	world_item.position = position
	world_item.velocity = Vector2(_rng.randf_range(-100, 100), -300)
	_level.add_child(world_item)

func spawn_object(_object_id: String, position: Vector2, direction: int) -> void:
	var bullet = _bullet.instance()
	bullet.position = position
	bullet.dir = direction
	_level.add_child(bullet)
	return

func spawn_mob(_mob_id: String, _position: Vector2) -> void:
	pass
	
func spawn_ray():
	var global_pos = _level.get_global_mouse_position()
	_context_cast.global_position = global_pos
	_context_cast.force_raycast_update()
	return _context_cast.get_collider()

func add_item_effect_to_collider(index: int) -> bool:
	if not _player.inventory.items[index]: return false
	var collider = spawn_ray()
	var item = Database.get_item_data(_player.inventory.get_id(index))
	if collider is WorldCharacter and can_use_effect(item.effect, collider):
		collider.add_effect(item.effect.unique_id, item)
		if item.consumable: _player.inventory.remove_item(index)
		return true
	return false
	
func can_use_item(index: int) -> bool:
	if not _player.inventory.items[index]: return false
	var collider = spawn_ray()
	var effect = Database.get_item_data(_player.inventory.get_id(index)).effect
	if collider is WorldCharacter and can_use_effect(effect, collider): return true
	return false

func can_use_effect(effect, collider) -> bool:
	if not effect: return false
	for target_effect in collider.effects.keys():
		# not efficient?
		var ed = Database.get_effect_data(target_effect)
		if ed.usable_effect.size() and ed.usable_effect.has(effect.unique_id): return false
	if effect.usable_npc.size() and collider is NPC and effect.usable_npc.has(collider.unique_id): return true
	if effect.usable_mob.size() and collider is Mob and effect.usable_mob.has(collider.unique_id): return true

	return true

### Dialogic

func update_quest_progress(quest):
	Dialogic.set_variable(quest, quests[quest].current_progress)
	
func progress_quest(quest):
	quests[quest].current_progress += 1
	update_quest_progress(quest)

func add_item_to_inventory(item, amount):
	# Maybe check first if it is possible to add,
	# then change dialog based on tthat
	if _player.inventory.add_item(item, int(amount)):
		pass

func check_item(item):
	Dialogic.set_variable(item, _player.inventory.get_amount(item))

func remove_item(item, amount):
	#TODO
	var stackable = Database.get_item_data(item).stackable
	for i in range(0, amount):
		var pos = _player.inventory.get_position(item)
		_player.inventory.remove_item(pos, int(amount))
		if stackable: break
		
# -_-
var _shop
func open_shop(shop_id: String):
	_shop = shop_id
	_ui.current_dialog.disconnect("timeline_end", _ui, "_dialogue_end")
	_ui.current_dialog.connect("timeline_end", self, "_show_shop")
	
func _show_shop(timeline_name):
	$UI/Control/TradeUI.set_shop(Database.get_shop_data(_shop))
	$UI/Control/TradeUI.set_inventory(_player.inventory)
	$UI/Control/TradeUI.show()
### Dialogic end

func _physics_process(_delta):
	_ui_info.update_strength_label(_player.stats.strength)
	_ui_info.update_intellect_label(_player.stats.intellect)
	_ui_info.update_dexterity_label(_player.stats.dexterity)
	_ui_info.update_renown_label(_player.stats.renown)
	_ui_info.update_state_label(_player.state.current_state.name)
	_ui_info.update_health_label(_player.stats.health, _player.stats.stamina * 10)

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		if not _ui_inventory.visible:
			_ui_inventory.show()
		else:
			_ui_inventory.hide()

func port_player(dest, dest_pos):
	if dest is Vector2:
		_player.position = dest
	if dest is String:
		var scene = ResourceLoader.load(dest)
		remove_child(_level)
		_level = scene.instance()
		add_child(_level)
		_player.position = dest_pos
		print(dest_pos)
		_player.camera.reset_smoothing()


func _on_info_pressed():
	_ui_info.visible = !_ui_info.visible


func _on_inventory_pressed():
	_inventory.visible = !_inventory.visible
