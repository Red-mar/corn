class_name Port
extends Area2D

export(NodePath) var destination
# Do take note that the node itself isn't being exported -
# there is one more step to call the true node:
onready var dest = get_node(destination)
