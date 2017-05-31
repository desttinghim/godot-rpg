extends CanvasLayer

signal complete
signal decision(string)

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
var cntr_decisions = null

func _ready():
	text = get_node("screen/dialog/text")
	text.connect("input_event", self, "_on_text_input")
	
	next = get_node("screen/dialog/next")
	next.connect("pressed", self, "next")
	
	decisions = get_node("screen/decisions/decisions")
	cntr_decisions = get_node("screen/decisions")
	set_process_input(true)

func _input(event):
	if event.is_action_released("ui_select"):
		next()

func add_dialog(line):
	pages.append(Page.new(PAGE_TYPE.dialog, line, "")) 

func add_decision(options):
	pages.append(Page.new(PAGE_TYPE.decision, "", options))

func start():
	load_page(page)
	next.grab_focus()

func load_page(pg):
	cntr_decisions.hide()
	if pg >= pages.size():
		print("Error! No such page...")
		return
	if pages[pg].type == PAGE_TYPE.dialog:
		text.set_bbcode(pages[pg].dialog)
		text.set_visible_characters(0)
		text.grab_focus()
	else:
		for option in pages[pg].decisions:
			var btn = Button.new()
			btn.set_text(option)
			btn.connect("pressed", self, "decision_callback", [option])
			decisions.add_child(btn)
		decisions.get_child(0).grab_focus()
		cntr_decisions.show()
	next.hide()

func next():
	if not all_characters_shown():
		text.set_visible_characters(text.get_total_character_count())
		return
	page += 1
	if page >= pages.size():
		emit_signal("complete")
		queue_free()
	else:
		load_page(page)

func decision_callback(option):
	emit_signal("decision", option)

func all_characters_shown():
	return text.get_visible_characters() >= text.get_total_character_count()

func _on_Timer_timeout():
	if all_characters_shown():
		next.show()
		next.grab_focus()
		get_node("Timer").stop()
	else:
		text.set_visible_characters(text.get_visible_characters()+1)
