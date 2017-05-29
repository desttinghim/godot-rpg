extends CanvasLayer

signal complete(flags)

export var dialog = ["default"]
export var page = 0

var text = null

func _ready():
	text = get_node("screen/text")
	set_process_input(true)

func load_page(pg):
	if dialog.size() > 0:
		text.set_bbcode(dialog[pg])
	text.set_visible_characters(0)

func input(event):
	if event.is_action_pressed("ui_select"):
		if page == dialog.size():
			emit_signal("complete")
		else:
			page += 1
			load_page(page)

func _on_Timer_timeout():
	text.set_visible_characters(text.get_visible_characters()+1)
