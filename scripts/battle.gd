extends Node

var Move = preload("res://scripts/move.gd")

var battle_menu = null
var battle_menu_focus = ""
var sub_menu = null

var combatants
var team_1
var team_2
var targeter

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

var main_menu = {moves = "showmenu_moves", items = "showmenu_items"}

func _ready():
	
	battle_menu = get_node("interface/cntr_battle_menu/BattleMenu")
	create_battle_menu(main_menu)
	show_battle_menu()
	
	sub_menu = get_node("interface/cntr_battle_menu/SubMenu")
	
	combatants = get_tree().get_nodes_in_group("combatant")
	team_1 = get_tree().get_nodes_in_group("team_1")
	team_2 = get_tree().get_nodes_in_group("team_2")
	targeter = get_node("interface/cntr_battle_menu/Targeter")
	
	set_process_input(true)

# Callbacks
var current_action
func btn_callback(txt):
	var call = txt.split("_")
	if call[0] == "showmenu" and call.size() > 1:
		if call[1] == "main":
			create_battle_menu(main_menu)
			show_battle_menu()
		elif call[1] == "moves":
			create_battle_menu(get_moves_menu("player"))
			show_battle_menu()
		elif call[1] == "items":
			pass # do nothing for now
	print(txt)

func get_moves_menu(node_name):
	var node
	for combatant in get_tree().get_nodes_in_group("combatant"):
		if combatant.get_name() == node_name:
			node = combatant
			break
	var moves = {}
	for child in node.get_children():
		print(child.get_type(), " : ", child.get_name())
		if child extends Move:
			moves[child.display_name] = str("move_", node.get_name(), "_", child.get_name())
	moves["back"] = "showmenu_main" 
	return moves

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

# Menu UI
func create_battle_menu(menu):
	for node in battle_menu.get_children():
		node.queue_free()
	for key in menu.keys():
		var btn = Button.new()
		btn.text = key
		btn.connect("pressed", self, "btn_callback", [menu[key]])
		battle_menu.add_child(btn)
		battle_menu_focus = btn.get_name()
	#battle_menu_focus = battle_menu.get_child(0).get_name()

func show_battle_menu():
	battle_menu.show()
	battle_menu.get_node(battle_menu_focus).grab_focus()

func hide_battle_menu():
	battle_menu.hide()

# Sub menu UI
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
	
# Targeting UI
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
