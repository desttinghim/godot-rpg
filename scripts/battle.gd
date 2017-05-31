extends Node

var Move = preload("res://scripts/move.gd")
var DialogBox = preload("res://dialog_box.tscn")

var battle_menu = null
var sub_menu = null

var combatants
var team_1
var team_2
var targeter

var main_menu = {Moves = "showmenu_moves", Items = "showmenu_items"}

func _ready():
	
	battle_menu = get_node("interface/cntr_battle_menu/BattleMenu")
	var focus = create_battle_menu(main_menu)
	show_battle_menu(focus)
	
	sub_menu = get_node("interface/cntr_battle_menu/SubMenu")
	
	combatants = get_tree().get_nodes_in_group("combatant")
	team_1 = get_tree().get_nodes_in_group("team_1")
	team_2 = get_tree().get_nodes_in_group("team_2")
	targeter = get_node("interface/cntr_battle_menu/Targeter")
	
	set_process_input(true)

# Callbacks
var partial_action
func btn_callback(txt):
	var call = txt.split("_")
	if call[0] == "showmenu" and call.size() > 1:
		if call[1] == "main":
			var focus = create_battle_menu(main_menu)
			if call.size() > 2: focus = call[2]
			show_battle_menu(focus)
		elif call[1] == "moves":
			var focus = create_battle_menu(get_moves_menu("player"))
			show_battle_menu(focus)
		elif call[1] == "items":
			pass # do nothing for now
	elif call[0] == "move":
		if call.size() <= 2: 
			print("Invalid move command")
			return
		var combatant = get_combatant(call[1])
		if combatant == null: 
			print("No such combatant??")
			return
		var move = get_move(combatant, call[2])
		if move == null:
			print("No such move??")
			return
		show_target_select("team_2")
		var target = yield(targeter, "select_callback")
		var dialog = DialogBox.instance()
		add_child(dialog)
		dialog.add_dialog(str(combatant.display_name, " uses ", move.display_name, " on ", target.display_name))
		dialog.start()
		yield(dialog, "complete")
		hide_target_select()
		var focus = create_battle_menu(main_menu)
		show_battle_menu(focus)
		
	print(txt)

func select_callback(target):
	hide_battle_menu()
	hide_target_select()
	create_battle_menu(main_menu)
	show_battle_menu()

# Menu UI
func create_battle_menu(menu):
	for node in battle_menu.get_children():
		node.queue_free()
	var first = true
	var focus
	for key in menu.keys():
		var btn = Button.new()
		btn.text = key
		btn.set_name(key)
		btn.connect("pressed", self, "btn_callback", [menu[key]])
		battle_menu.add_child(btn)
		if first: 
			first = false
			focus = btn.get_name()
	return focus

func show_battle_menu(focus):
	battle_menu.show()
	battle_menu.get_node(focus).grab_focus()

func hide_battle_menu():
	battle_menu.hide()

# Targeting UI
func show_target_select(group):
	for target in get_tree().get_nodes_in_group(group):
		var selector = Button.new()
		selector.set_pos(target.get_pos())
		selector.set_text(target.get_name())
		selector.connect("pressed", targeter, "target_selected", [target])
		targeter.add_child(selector)
	targeter.show()
	targeter.get_children()[0].grab_focus()

func hide_target_select():
	for selector in targeter.get_children():
		selector.queue_free()
	targeter.hide()

# Utilities
func get_moves_menu(name):
	var combatant = get_combatant(name)
	var moves = {}
	for child in combatant.get_children():
		if child extends Move:
			moves[child.display_name] = str("move_", combatant.get_name(), "_", child.get_name())
	moves["Back"] = "showmenu_main_Moves" 
	return moves

func get_combatant(name):
	for combatant in get_tree().get_nodes_in_group("combatant"):
		if combatant.get_name() == name:
			return combatant
	return null

func get_move(combatant, name):
	for child in combatant.get_children():
		if child extends Move:
			if child.get_name() == name:
				return child 
	return null
