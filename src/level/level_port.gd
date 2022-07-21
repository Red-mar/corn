class_name LevelPort
extends Area2D

export(String, FILE) var destination
export(Vector2) var destination_position
# Do take note that the node itself isn't being exported -
# there is one more step to call the true node:
#vonready var loc = get_node(port_loc_node)
