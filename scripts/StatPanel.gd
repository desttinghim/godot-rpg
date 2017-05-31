extends Panel

export(NodePath) var combatant_path = ""
var combatant

func _ready():
	if combatant_path != "":
		set_combatant(get_node(combatant_path))

func set_combatant(node):
	combatant = node
	get_node("Name").set_text(combatant.display_name)
	get_node("Health").set_max(combatant.health)
	get_node("Power").set_max(combatant.power)
	reload()

func reload():
	var state = combatant.get_current_state()
	get_node("Health").set_value(state.health)
	get_node("Power").set_value(state.power)
	pass