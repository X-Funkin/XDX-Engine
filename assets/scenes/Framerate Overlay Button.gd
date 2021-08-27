extends HBoxContainer


export(int, "OFF", "ON") var fps_overlay = 0 setget set_fps_overlay
export(NodePath) var fnf_button_node
export(float) var focus_pos = 0.0 setget set_focus_pos

func set_fps_overlay(n_fps_overlay):
	fps_overlay = n_fps_overlay
	if not is_inside_tree(): yield(self, "ready")
	var text = ""
	match fps_overlay:
		0:
			text = "OFF"
		1:
			text = "ON"
	$Label.text = ":  "+text
	update_fps_overlay()

func update_fps_overlay():
	if fps_overlay == 1:
		GameData.data.video_settings.fps_overlay = true
	else:
		GameData.data.video_settings.fps_overlay = false

func set_focus_pos(n_pos):
	focus_pos = n_pos
	if get_parent().has_method("refocus"):
		get_parent().focus_pos = n_pos
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#func refocus():
#	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.modulate = get_node(fnf_button_node).unfocused_color
	$Label/Label.visible = false
	if GameData.data.video_settings.fps_overlay:
		$Label.text = ":  ON"
	else:
		$Label.text = ":  OFF"
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
		self.fps_overlay = posmod(fps_overlay-1, 2)
	if event.is_action_pressed("ui_right"):
		self.fps_overlay = posmod(fps_overlay+1, 2)
#	if event.is_action_pressed("ui_left"):
#		self.framerate = posmod(framerate-1, 12)
#	if event.is_action_pressed("ui_right"):
#		self.framerate = posmod(framerate+1, 12)
#		self.resolution = posmod(resolution-1, 10)
#	if event.is_action_pressed("ui_right"):
#		self.resolution = posmod(resolution+1, 10)
#		self.window_mode = posmod(window_mode-1, 3)
#	if event.is_action_pressed("ui_right"):
#		self.window_mode = posmod(window_mode+1, 3)
	pass # Replace with function body.
