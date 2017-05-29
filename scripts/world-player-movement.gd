extends Sprite

var endPos = Vector2(0, 0)
var startPos = Vector2(0, 0)
var tween = null
var moving = false

const GRID = 16
const WALK_TIME = 0.25
const SPRINT_TIME = 0.15

func _ready():
	set_fixed_process( true )
	
	startPos = get_pos()
	endPos = startPos
	
	if has_node("Tween"):
		tween = get_node("Tween")
	else:
		tween = add_child(Tween)

func _fixed_process(delta):
	if !moving:
		if Input.is_action_pressed("ui_up"):
			move(Vector2(0, -1))
		elif Input.is_action_pressed("ui_down"):
			move(Vector2(0, 1))
		elif Input.is_action_pressed("ui_left"):
			move(Vector2(-1, 0))
		elif Input.is_action_pressed("ui_right"):
			move(Vector2(1, 0))

func move(dir):
	moving = true
	startPos = get_pos()
	endPos = Vector2(startPos.x + dir.x * GRID, startPos.y + dir.y * GRID)
	
	tween.interpolate_property(self, "transform/pos", startPos, endPos, 
								WALK_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func _on_tween_complete( object, key ):
	moving = false
	startPos = endPos
