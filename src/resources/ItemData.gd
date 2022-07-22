class_name ItemData
extends Resource

export var unique_id := ""
export var display_name := ""
export var description := ""

export var value := 0
export var stackable := false
# Delete on use"res://src/resources/items/potion.tres"
export var consumable := false

export var icon: Texture
export var animation: SpriteFrames

export var effect: Resource

var position = null
