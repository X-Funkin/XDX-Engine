extends HBoxContainer



export(int, "256x144", "640x360", "1024x576", "1152x648", "1280x720", "1336x768", "1600x900", "1920x1080", "2560x1440", "3840x2160") var resolution = 7 setget set_resolution
export(NodePath) var fnf_button_node
export(float) var focus_pos = 0.0 setget set_focus_pos


func set_resolution(n_resolution):
	resolution = n_resolution
	if not is_inside_tree(): yield(self, "ready")
	var text = ""
	match resolution:
		0:
			text = "256x144"
		1:
			text = "640x360"
		2:
			text = "1024x576"
		3:
			text = "1152x648"
		4:
			text = "1280x720"
		5:
			text = "1336x768"
		6:
			text = "1600x900"
		7:
			text = "1920x1080"
		8:
			text = "2560x1440"
		9:
			text = "3840x2160"
	$Label.text = ":  "+text
	update_resolution()

func update_resolution():
	var res = [1920,1080]
	match resolution:
		0:
			res = [256,144]
		1:
			res = [640,360]
		2:
			res = [1024,576]
		3:
			res = [1152,648]
		4:
			res = [1280,720]
		5:
			res = [1336,768]
		6:
			res = [1600,900]
		7:
			res = [1920,1080]
		8:
			res = [2560,1440]
		9:
			res = [3840,2160]
	GameData.data.video_settings.resolution = res

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
	$Label.text = ":  %sx%s"%GameData.data.video_settings.resolution
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
		self.resolution = posmod(resolution-1, 10)
	if event.is_action_pressed("ui_right"):
		self.resolution = posmod(resolution+1, 10)
#		self.window_mode = posmod(window_mode-1, 3)
#	if event.is_action_pressed("ui_right"):
#		self.window_mode = posmod(window_mode+1, 3)
	pass # Replace with function body.
