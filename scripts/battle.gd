extends Node

var battle_menu = null
var battle_menu_focus = "Items"

var melee_menu = null
var melee_menu_focus = "Punch"

func _ready():
	battle_menu = get_node("interface/cntr_battle_menu/BattleMenu")
	battle_menu.get_node("Melee").connect("pressed", self, "show_melee_menu")
	battle_menu.get_node(battle_menu_focus).grab_focus()
	
	melee_menu = get_node("interface/cntr_battle_menu/MeleeMenu")
	melee_menu.get_node("Back").connect("pressed",  self, "hide_melee_menu")
	
	set_process_input(true)

func show_melee_menu():
	battle_menu_focus = battle_menu.get_path_to(battle_menu.get_focus_owner())
	melee_menu.show()
	melee_menu.get_node(melee_menu_focus).grab_focus()

func hide_melee_menu():
	melee_menu.hide()
	battle_menu.get_node(battle_menu_focus).grab_focus()