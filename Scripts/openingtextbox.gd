extends CanvasLayer

const CHAR_RATE = 0.075
@onready var textbox_container = $TextboxContainer
@onready var lable = $TextboxContainer/MarginContainer/HBoxContainer/Label
@onready var tween = create_tween()

enum State {
	READY,
	READING,
	FINISHED
}
var current_state = State.READY
var text_queue = []
func _ready():
	$TextboxContainer/MarginContainer/HBoxContainer/Timer.wait_time = CHAR_RATE
	_hide_text_box()
	_queue_text("hello im clive")
	_queue_text("hello im clive2")
	_queue_text("hello im clive3")
	_queue_text("hello im clive4")
	pass

func _process(delta):
	match current_state :
		State.READY :
			if !text_queue.is_empty() :
				_diplay_text()
		State.READING :
			if Input.is_action_just_pressed("ui_accept") :
				tween.stop()
				lable.visible_ratio = 1.0
				_change_state(State.FINISHED)
		State.FINISHED :
			if Input.is_action_just_pressed("ui_accept") :
				_change_state(State.READY)
				_hide_text_box()

func _queue_text(next_text):
	text_queue.push_back(next_text)
	pass

func _hide_text_box():
	lable.text = ""
	textbox_container.hide()

func _show_text_box():
	textbox_container.show()

func _diplay_text():
	var next_text = text_queue.pop_front()
	_change_state(State.READING)
	$TextboxContainer/MarginContainer/HBoxContainer/Timer.start()
	lable.text = next_text
	_show_text_box()
	tween.tween_property(lable , "visible_ratio", 1.0, CHAR_RATE)

func _change_state(next_state):
	current_state = next_state
	match current_state :
		State.READY :
			pass
		State.READING :
			pass
		State.FINISHED :
			pass



func _on_timer_timeout():
	$TextboxContainer/MarginContainer/HBoxContainer/Timer.stop()
	_change_state(State.FINISHED)
