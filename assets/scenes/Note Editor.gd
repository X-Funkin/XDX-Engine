extends Control
class_name NoteEditor

export(float) var song_time = 0.0 setget set_song_time
export(float) var zoom = 1.0 setget set_zoom
export(float) var zoom_level = 0.0 setget set_zoom_level
export(float) var zoom_speed = 1.0
export(int, "None", "Move", "Zoom", "Playback") var transform_mode = 0

func set_zoom(n_zoom):
	zoom = abs(n_zoom)
	zoom_level = log(zoom)/log(10.0)
	get_tree().call_group("Zoom Recievers", "recieve_zoom", zoom)

func set_zoom_level(n_zoom_level):
	zoom_level = n_zoom_level
	zoom = pow(10.0,zoom_level)
	get_tree().call_group("Zoom Recievers", "recieve_zoom", zoom)

func set_song_time(n_song_time):
	song_time = n_song_time
	get_tree().call_group("Song Time Recievers", "recieve_song_time", song_time)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func get_control_children(control_node):
	var children = []
	for node in control_node.get_children():
		if node.get_child_count() > 0:
			children.append_array(get_control_children(node))
		if node is Control:
			children.append(node)
	return children

func un_mouse_input_lol():
	for child in get_control_children(self):
		child.mouse_filter = MOUSE_FILTER_IGNORE

func re_mouse_input_ig():
	for node in get_tree().get_nodes_in_group("Mouse Input Pass"):
		for child in get_control_children(node):
			child.mouse_filter = MOUSE_FILTER_PASS


func connect_all_control_signals(connect_signal, connect_function):
	var script = load("res://assets/scenes/GUI Input Test.gd")
	for child in get_control_children(self):
		child.connect(connect_signal, self, connect_function)
		if child.get_script() == null:
			child.set_script(script)
#			child.connect("gui_input", child, "print_gui_input")
#			set_script()
			pass
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
#	connect_all_control_signals("gui_input", "print_gui_input")
	un_mouse_input_lol()
	re_mouse_input_ig()
	pass # Replace with function body.


func print_gui_input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		print(event)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(get_global_mouse_position())
#	pass


func _on_Instumental_Track_Input_Area_input_event(viewport, event, shape_idx):
#	print("eyaidhf event ", event)
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			transform_mode = 1
			if Input.is_key_pressed(KEY_SHIFT):
				transform_mode = 2
		else:
			transform_mode = 0
	if event is InputEventKey:
		if event.scancode == KEY_SHIFT and event.pressed and Input.is_mouse_button_pressed(1):
			transform_mode = 2
	if event is InputEventMouseMotion:
		match transform_mode:
			1:
				self.song_time += -event.relative.y/zoom
#				event.relative
			2:
				self.zoom_level += -event.relative.y*zoom_speed
				self.song_time += -event.relative.y/zoom
	pass # Replace with function body.


func _on_Instumental_Track_Input_Area_mouse_entered():
	print("bruhburhguheidi")
	pass # Replace with function body.


func _on_Button4_pressed():
	$Popups/FileDialog.popup()
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	var thingy = ChartEditor.new()
	var stream = thingy.load_wav_file(path)
	get_tree().call_group("Enemy Audio Stream Recievers", "recieve_enemy_audio_stream", stream)
	pass # Replace with function body.
