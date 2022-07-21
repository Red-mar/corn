class_name EffectData
extends Resource

export var unique_id := ""
export var display_name := ""
export var description := ""
export var icon: Texture

# 0 is instant
export var duration := 0.0
# duration 1 and interval .5 = 2 ticks
# duration 1 and interval 0 = 1 tick
export var interval := 0.0

# Adjustments resources
export var health := 0
export var mana := 0

# Adjustments stats
export var max_health := 0
export var strength := 0

export var drop_item: String

export(Dictionary) var usable_mob
export(Dictionary) var usable_npc
export(Dictionary) var usable_item

export(Dictionary) var usable_effect

export(PackedScene) var particles

export(Script) var custom

# Effect triggered after this one
export var chain_effect := ""

var stats: Character
