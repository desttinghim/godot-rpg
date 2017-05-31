extends Node

export var display_name = "Move"
export var cost = 0
export(String, MULTILINE) var _stats = ""
var stats = {}

func _ready():
	stats.parse_json(str('{', _stats, '}'))
