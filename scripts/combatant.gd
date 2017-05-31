extends Node2D

export(String) var display_name = "Combatant"
export(int) var power = 1
export(int) var health = 50
# figure out a sane way to export the modifiers
export(String, MULTILINE) var editor_stats = ""
export(String, MULTILINE) var editor_moves = ""

var stats = {}
var moves = {}

var modifiers = ["blunt", "sharp", "ranged", "sly", "fire", "water", "earth", "air", "spirit"]

func _ready():
	stats.parse_json(editor_stats)
	for modifier in stats:
		if not stats.has(modifier):
			stats[modifier] = 1
	moves.parse_json(editor_moves)
# Basic attack modifiers
const BLUNT = "blunt"
const SHARP = "sharp"
const RANGED = "ranged"
const SLY = "sly"
# Five elements
const FIRE = "fire"
const WATER = "water"
const EARTH = "earth"
const AIR = "air"
const SPIRIT = "spirit"
func take_damage(attack):
	var damage
	for modifier in attack.keys():
		damage = attack[modifier] * stats[modifier]
	health -= damage
	return damage