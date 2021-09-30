extends Control
class_name NoteEditor

export(float) var song_time = 0.0 setget set_song_time
export(float) var zoom = 1.0 setget set_zoom
export(float) var zoom_level = 0.0 setget set_zoom_level
export(float) var zoom_speed = 1.0
export(int, "None", "Move", "Zoom", "Playback") var transform_mode = 0 setget set_transform_mode
export(float) var scrolling_speed = 0.0
export(float) var scrolling_damp = 1000.0
export(int) var scrolling_direction = 1
export(bool) var snapping = true
export(float) var bpm = 120.0
export(float) var snapping_offset = 0.0
export(float) var song_time_cursor = 0.0
export(Vector2) var editor_cursor
export(NodePath) var waveform


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

func set_transform_mode(n_mode):
	transform_mode = n_mode
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func song_time_transform(pos_y):
	return (get_node(waveform).global_transform.affine_inverse()*Vector2(0,pos_y)).y

func inv_song_time_transform(song_time):
	return (get_node(waveform).global_transform*Vector2(0,song_time)).y


func update_song_time_cursor():
	if snapping:
		var snap_length = 60.0/(bpm*4.0*max(1.0,floor(zoom)))
		var snapped_song_time = stepify(song_time_transform(get_global_mouse_position().y),snap_length*1000.0)+snapping_offset
		song_time_cursor = snapped_song_time
	else:
		song_time_cursor = song_time_transform(get_global_mouse_position().y)
	
	get_tree().call_group("Cursor Recievers", "recieve_song_time_cursor", song_time_cursor)
#	$"Main UI/Track UI/Arrow Track Control/Audio Waveforms/Enemy Vocals/Position2D/debug_texture".global_position.y = inv_song_time_transform(song_time_cursor)
#	$"Main UI/Track UI/Arrow Track Control/Audio Waveforms/Enemy Vocals/Position2D/debug_texture".scale.y = 0.1/zoom
#	$"Main UI/Track UI/Arrow Track Control/Audio Waveforms/Enemy Vocals/Position2D/debug_texture".position.y = song_time_cursor
	pass

func update_editor_cursor():
	editor_cursor = get_global_mouse_position()
	if snapping:
		editor_cursor.y = inv_song_time_transform(song_time_cursor)
	get_tree().call_group("Cursor Recievers", "recieve_editor_cursor", editor_cursor)

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
	get_tree().call_group("Zoom Recievers", "recieve_zoom", zoom)
	pass # Replace with function body.


func print_gui_input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		print(event)
	pass

func _input(event):
	if event is InputEventMouseButton:
		print(song_time_cursor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_song_time_cursor()
	update_editor_cursor()
	if transform_mode == 0 and scrolling_speed != 0.0:
		self.song_time += scrolling_speed*delta/zoom
		scrolling_direction = sign(scrolling_speed)
		scrolling_speed -= scrolling_damp*delta*scrolling_direction
		if sign(scrolling_speed) != scrolling_direction:
			scrolling_speed = 0.0
		
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
				scrolling_speed = -event.speed.y
#				event.relative
			2:
				self.zoom_level += -event.relative.y*zoom_speed
				self.song_time += -event.relative.y/zoom
	pass # Replace with function body.


func _on_Instumental_Track_Input_Area_mouse_entered():
#	print("bruhburhguheidi")
	get_tree().call_group("Track Input Recievers", "recieve_track_mouse_entered", 3, 0)
	pass # Replace with function body.


func _on_Button4_pressed():
	$Popups/FileDialog.popup()
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	var thingy = ChartEditor.new()
	var stream = thingy.load_wav_file(path)
	get_tree().call_group("Audio Stream Recievers", "recieve_enemy_audio_stream", stream)
	pass # Replace with function body.


func _on_Instumental_Track_Input_Area_mouse_exited():
	transform_mode = 0
	pass # Replace with function body.
