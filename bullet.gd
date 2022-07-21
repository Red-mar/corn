extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dir = 1
var velocity = 400
onready var _b_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	_b_timer.connect("timeout", self, "queue_free")
	_b_timer.start()
	if dir != 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false


func _physics_process(delta):
	position.x += velocity * dir * delta


func _on_bullet_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body is Mob:
		body.damage("damage", position)
		#queue_free()
