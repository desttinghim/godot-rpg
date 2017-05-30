extends Node

var battle_menu = null
var battle_menu_focus = "Items"
var sub_menu = null

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
	
	set_process_input(true)

func btn_callback(txt):
	print(txt)

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