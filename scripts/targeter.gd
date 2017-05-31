extends Container

signal select_callback(target)

func target_selected(target):
	emit_signal("select_callback", target)