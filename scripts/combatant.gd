extends Node2D

export(String) var display_name = "Combatant"
export(int) var power = 1
export(int) var health = 50
# figure out a sane way to export the modifiers
export(String, MULTILINE) var _stats = ""

signal hit_target
signal back_to_start

var stats = {}
var actions = []

var modifiers = ["blunt", "sharp", "ranged", "sly", "fire", "water", "earth", "air", "spirit"]

onready var tween = get_node("Tween")
onready var animate = get_node("AnimationPlayer")

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

func animate_move(move, target):
	var startPos = get_pos()
	var endPos = target.get_pos()
	endPos.x -= target.get_node("Sprite").get_texture().get_width()
	tween.set_active(true)
	tween.interpolate_property(self, "transform/pos", startPos, endPos,
						1.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	animate.play("Walk")
	print("Walking...")
	yield(tween, "tween_complete")
	print("Executing move...")
	animate.stop()
	if animate.has_animation(move.animation):
		animate.play(move.animation)
	else:
		animate.play("Punch")
	yield(animate, "finished")
	print("Moving back to start...")
	animate.stop_all()
	emit_signal("hit_target")
	tween.interpolate_property(self, "transform/pos", get_pos(), startPos,
								.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_complete")
	print("Done!")
	emit_signal("back_to_start")
	