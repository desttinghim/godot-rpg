extends Node

export var display_name = "Move"
export var cost = 0
const TARGET_TEAM = -1
const TARGET_ALL = -2
export var targets = 1
# turn on friendly
export(String, "Enemies", "Friends", "Both") var can_target = "Enemies"
export(String, MULTILINE) var _stats = ""
var stats = {}

func _ready():
	stats.parse_json(str('{', _stats, '}'))
