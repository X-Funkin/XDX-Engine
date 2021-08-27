extends HBoxContainer



export(int, "Fullscreen", "Windowed", "Windowed Boarderless") var window_mode = 0 setget set_window_mode
export(NodePath) var fnf_button_node
export(float) var focus_pos = 0.0 setget set_focus_pos


func set_window_mode(n_mode):
	window_mode = n_mode
	if not is_inside_tree(): yield(self, "ready")
	match window_mode:
		0:
			$Label.text = ":  Fullscreen"
		1:
			$Label.text = ":  Windowed"
		2:
			$Label.text = ":  Boarderless"
	update_window_mode()

func update_window_mode():
	GameData.data.video_settings.window_mode = window_mode

func set_focus_pos(n_pos):
	focus_pos = n_pos
	if get_parent().has_method("refocus"):
		print("yeah got to the window pos")
		get_parent().focus_pos = n_pos
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#
#func refocus():
#	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.modulate = get_node(fnf_button_node).unfocused_color
	$Label/Label.visible = false
	self.window_mode = GameData.data.video_settings.window_mode
#	var test_dict = {
#		"yeah": 0,
#		0: 1920,
#		1: 1080,
#		"x": 1920,
#		"y": 1080
#	}
#	print(test_dict.yeah)
#	print(test_dict[0])
#	print(test_dict.y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FNF_Button_focus_entered():
	$Label.modulate = get_node(fnf_button_node).focused_color
	$Label/Label.visible = true
	self.focus_pos = rect_position.y
	pass # Replace with function body.


func _on_FNF_Button_focus_exited():
	$Label.modulate = get_node(fnf_button_node).unfocused_color
	$Label/Label.visible = false
	pass # Replace with function body.


func _on_FNF_Button_gui_input(event):
	if event.is_action_pressed("ui_left"):
		self.window_mode = posmod(window_mode-1, 3)
	if event.is_action_pressed("ui_right"):
		self.window_mode = posmod(window_mode+1, 3)
	pass # Replace with function body.
