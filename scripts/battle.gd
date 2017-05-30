extends Node

var battle_menu = null
var battle_menu_focus = "Items"
var sub_menu = null

var combatants
var team_1
var team_2
var targeter

class Combatant:
	var side
	var stats = {"hp":3, "mp":3, "max_hp":3, "max_mp":3}
	func _init(stats):
		self.stats = stats

class Action:
	var origins = []
	var targets = []
	var stats = {"dmg":0, "cost":0}
	func add_origin(node):
		origins.append(node)
	func add_target(node):
		targets.append(node)
	func set_stat(stat, val):
		stats[stat] = val

func _ready():
	var melee_menu = {"Punch": "melee_punch"}
	var ranged_menu = {"Shoot": "ranged_shot"}
	var magic_menu = {"Heal": "magic_heal"}
	var item_menu = {"Cookie": "item_cookie"}
	
	battle_menu = get_node("interface/cntr_battle_menu/BattleMenu")
	battle_menu.get_node("Melee").connect("pressed", self, "show_menu", [melee_menu])
	battle_menu.get_node("Ranged").connect("pressed", self, "show_menu", [ranged_menu])
	battle_menu.get_node("Magic").connect("pressed", self, "show_menu", [magic_menu])
	battle_menu.get_node("Items").connect("pressed", self, "show_menu", [item_menu])
	battle_menu.get_node(battle_menu_focus).grab_focus()
	
	sub_menu = get_node("interface/cntr_battle_menu/SubMenu")
	
	combatants = get_tree().get_nodes_in_group("combatant")
	team_1 = get_tree().get_nodes_in_group("team_1")
	team_2 = get_tree().get_nodes_in_group("team_2")
	targeter = get_node("interface/cntr_battle_menu/Targeter")
	
	set_process_input(true)

var current_action
func btn_callback(txt):
	if txt.split("_")[0] == "melee":
		show_target_select("team_2")
		sub_menu.release_focus()
		current_action = Action.new()
		current_action.set_stat("dmg", 3)
		current_action.set_stat("cost", 3)
		current_action.add_origin(get_node("battlground/player"))
	print(txt)

func select_callback(target):
	current_action.add_target(target)
	hide_menu()
	hide_target_select()
	apply_action(current_action)

var action_history = []
func apply_action(action):
	for origin in action.origins:
		print(origin.get_name(), " uses ", action.stats["cost"], " mana.")
	for target in action.targets:
		print(target.get_name(), " takes ", action.stats["dmg"], " damage.")
	action_history.append(action)

func show_menu(menu):
	battle_menu_focus = battle_menu.get_path_to(battle_menu.get_focus_owner())
	for item in menu.keys():
		var btn = Button.new()
		btn.text = item 
		btn.connect("pressed", self, "btn_callback", [menu[item]])
		sub_menu.add_child(btn)
	var back_btn = Button.new()
	back_btn.text = "Back"
	back_btn.connect("pressed", self, "hide_menu")
	sub_menu.add_child(back_btn)
	
	sub_menu.show()
	sub_menu.get_child(0).grab_focus()

func hide_menu():
	sub_menu.hide()
	for node in sub_menu.get_children():
		node.queue_free()
	battle_menu.get_node(battle_menu_focus).grab_focus()

func show_target_select(group):
	for target in get_tree().get_nodes_in_group(group):
		var selector = Button.new()
		selector.set_pos(target.get_pos())
		selector.set_text(target.get_name())
		selector.connect("pressed", self, "select_callback", [target])
		targeter.add_child(selector)
	targeter.show()
	targeter.get_children()[0].grab_focus()

func hide_target_select():
	for selector in targeter.get_children():
		selector.queue_free()
	targeter.hide()