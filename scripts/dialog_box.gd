extends CanvasLayer

signal complete

enum PAGE_TYPE {
	dialog,
	decision
}
class Page:
	var type = PAGE_TYPE.dialog
	var dialog = ""
	var decisions = []
	func _init(type, dialog, decisions):
		self.type = type
		self.dialog = dialog
		self.decisions = decisions

var pages = []
var page = 0

var text = null
var next = null
var decisions = null

func _ready():
	text = get_node("screen/text")
	next = get_node("screen/next")
	decisions = get_node("screen/decisions")
	next.connect("pressed", self, "next")
	connect("complete", self, "test_signal_complete")
	set_process_input(true)

func add_dialog(line):
	pages.append(Page.new(PAGE_TYPE.dialog, line, "")) 

func add_decision(options):
	pages.append(Page.new(PAGE_TYPE.decision, "", options))

func start():
	load_page(page)
	next.grab_focus()

func load_page(pg):
	if pg >= pages.size():
		print("Error! No such page...")
		return
	if pages[pg].type == PAGE_TYPE.dialog:
		text.set_bbcode(pages[pg].dialog)
	else:
		for option in pages[pg].decisions:
			var btn = Button.new()
			btn.set_text(option)
			decisions.add_child(btn)
	text.set_visible_characters(0)
	next.hide()
	text.grab_focus()

func next():
	page += 1
	if page >= pages.size():
		emit_signal("complete")
		queue_free()
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
