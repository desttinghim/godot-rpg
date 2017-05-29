extends CanvasLayer

signal complete

export var dialog = ["default"]
export var page = 0

var text = null
var next = null

func _ready():
	text = get_node("screen/text")
	next = get_node("screen/next")
	next.connect("pressed", self, "next")
	connect("complete", self, "test_signal_complete")
	set_process_input(true)

func add_dialog(line):
	dialog.append(line)

func start():
	load_page(page)
	next.grab_focus()

func load_page(pg):
	if pg < dialog.size():
		text.set_bbcode(dialog[pg])
	text.set_visible_characters(0)
	next.hide()
	text.grab_focus()

func next():
	page += 1
	if page >= dialog.size():
		emit_signal("complete")
	else:
		load_page(page)

func test_signal_complete():
	print("complete! YAY")

func _on_Timer_timeout():
	if text.get_visible_characters() >= text.get_total_character_count():
		next.show()
		next.grab_focus()
		get_node("Timer").stop()
	else:
		text.set_visible_characters(text.get_visible_characters()+1)
