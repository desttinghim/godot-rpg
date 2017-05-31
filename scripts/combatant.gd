extends Node2D

export(String) var display_name = "Combatant"
export(int) var power = 1
export(int) var health = 50
# figure out a sane way to export the modifiers
export(String, MULTILINE) var _stats = ""

var stats = {}

var modifiers = ["blunt", "sharp", "ranged", "sly", "fire", "water", "earth", "air", "spirit"]

func _ready():
	stats.parse_json(str("{",_stats,"}"))
	for modifier in modifiers:
		if not stats.has(modifier):
			stats[modifier] = 1

func take_damage(attack):
	var damage
	for modifier in attack.keys():
		damage = attack[modifier] * stats[modifier]
	health -= damage
	return damage