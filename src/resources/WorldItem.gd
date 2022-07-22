class_name WorldItem
extends KinematicBody2D

export var unique_id: String = ""
var _item: ItemData
var description = ""
var amount = 1

onready var _anim = $AnimationPlayer
onready var _sprite = $AnimatedSprite

const STOP_FORCE := 1000
var velocity = Vector2.ZERO
onready var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	_item = Database.get_item_data(unique_id)
	name = _item.display_name
	description = _item.description
	if _item.animation:
		_sprite.frames = _item.animation
	_anim.play("appear")

func _physics_process(delta):
	#if velocity.y != 0 and _anim.is_playing():
	#	_anim.stop()
	if is_on_floor() and !_anim.is_playing():
		_anim.play("item")

	if velocity.y == 0:
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	
	velocity.y += (GRAVITY * 5) * delta
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP, true, 4, 1.1)

func pickup() -> void:
	_anim.play("dissapear")
	# Disable further collision
	collision_layer = 0

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dissapear":
		queue_free()
