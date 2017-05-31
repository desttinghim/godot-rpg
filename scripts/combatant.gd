extends Node2D

export(String) var display_name = "Combatant"
export(int) var power = 1
export(int) var health = 50
# figure out a sane way to export the modifiers
export(String, MULTILINE) var _stats = ""

var stats = {}
var actions = []

var modifiers = ["blunt", "sharp", "ranged", "sly", "fire", "water", "earth", "air", "spirit"]

func _ready():
	stats.parse_json(str("{",_stats,"}"))
	for modifier in modifiers:
		if not stats.has(modifier):
			stats[modifier] = 1

func apply_action(action):
	actions.append(action)
	return get_current_state()

func calc_action_result(action):
	var hp = 0
	for modifier in action.keys():
		hp += action[modifier] * stats[modifier]
	return hp

func get_current_state():
	var hp = health
	var pp = power
	for action in actions:
		hp += calc_action_result(action)
		#pp += action.pp
	return {health=hp, power=pp, stats=stats}