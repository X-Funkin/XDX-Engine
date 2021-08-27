extends HBoxContainer


export(int, "20fps", "24fps", "30fps", "50fps", "60fps", "75fps", "100fps", "120fps", "144fps", "240fps", "360fps", "Max fps") var framerate = 11 setget set_framerate
export(NodePath) var fnf_button_node
export(float) var focus_pos = 0.0 setget set_focus_pos


func set_framerate(n_framerate):
	framerate = n_framerate
	if not is_inside_tree(): yield(self, "ready")
	var text = ""
	match framerate:
		0:
			text = "20 FPS"
		1:
			text = "24 FPS"
		2:
			text = "30 FPS"
		3:
			text = "50 FPS"
		4:
			text = "60 FPS"
		5:
			text = "75 FPS"
		6:
			text = "100 FPS"
		7:
			text = "120 FPS"
		8:
			text = "144 FPS"
		9:
			text = "240 FPS"
		10:
			text = "360 FPS"
		11:
			text = "Max FPS"
	$Label.text = ":  "+text
	update_framerate()

func update_framerate():
	var fps = 60
	match framerate:
		0:
			fps = 20
		1:
			fps = 24
		2:
			fps = 30
		3:
			fps = 50
		4:
			fps = 60
		5:
			fps = 75
		6:
			fps = 100
		7:
			fps = 120
		8:
			fps = 144
		9:
			fps = 240
		10:
			fps = 360
	GameData.data.video_settings.framerate = fps
	if framerate == 11:
		GameData.data.video_settings.framerate_max = true
	else:
		GameData.data.video_settings.framerate_max = false

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
	if GameData.data.video_settings.framerate_max:
		$Label.text = ":  Max FPS"
	else:
		$Label.text = ":  %s FPS"%GameData.data.video_settings.framerate
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
		self.framerate = posmod(framerate-1, 12)
	if event.is_action_pressed("ui_right"):
		self.framerate = posmod(framerate+1, 12)
#		self.resolution = posmod(resolution-1, 10)
#	if event.is_action_pressed("ui_right"):
#		self.resolution = posmod(resolution+1, 10)
#		self.window_mode = posmod(window_mode-1, 3)
#	if event.is_action_pressed("ui_right"):
#		self.window_mode = posmod(window_mode+1, 3)
	pass # Replace with function body.
