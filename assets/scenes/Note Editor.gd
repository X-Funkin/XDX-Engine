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
export(float) var bpm = 120.0 setget set_bpm
export(float) var snapping_offset = 0.0 setget set_snapping_offset
export(float) var song_time_cursor = 0.0
export(Vector2) var editor_cursor
export(NodePath) var waveform
var note_clipboard = []


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
	if not is_inside_tree(): yield(self,"ready")
	if transform_mode == 3:
		$"Main UI/Track UI/Snapping Grid".visible = false
		$"Main UI/Track UI/Arrow Track Control/Audio Waveforms".visible = false
		pass
#		$"Main UI/Track UI/Snapping Grid".modulate = Color.transparent
#		$"Main UI/Track UI/Arrow Track Control/Audio Waveforms".modulate = Color.transparent
	else:
		$"Main UI/Track UI/Snapping Grid".visible = true
		$"Main UI/Track UI/Arrow Track Control/Audio Waveforms".visible = true
		pass
#		$"Main UI/Track UI/Snapping Grid".modulate = Color.white
#		$"Main UI/Track UI/Arrow Track Control/Audio Waveforms".modulate = Color.white
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_bpm(n_bpm):
	bpm=n_bpm
	if not is_inside_tree(): yield(self,"ready")
	get_tree().call_group("Song Time Recievers", "recieve_bpm", bpm)

func set_snapping_offset(n_offset):
	snapping_offset = n_offset
	if not is_inside_tree(): yield(self, "ready")
	get_tree().call_group("Song Time Recievers", "recieve_snapping_offset", snapping_offset)



func song_time_transform(pos_y):
	return (get_node(waveform).global_transform.affine_inverse()*Vector2(0,pos_y)).y

func inv_song_time_transform(song_time):
	return (get_node(waveform).global_transform*Vector2(0,song_time)).y


func update_song_time_cursor():
	if snapping:
		var snap_length = 60.0/(bpm*4.0*max(1.0,floor(zoom)))
		var snapped_song_time = stepify(song_time_transform(get_global_mouse_position().y)-snapping_offset,snap_length*1000.0)+snapping_offset
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
	for node in get_tree().get_nodes_in_group("Mouse Input Ignore"):
		node.mouse_filter = MOUSE_FILTER_IGNORE


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
	$"Popups/Help Popups/Help".popup()
	get_tree().call_group("Zoom Recievers", "recieve_zoom", zoom)
	pass # Replace with function body.


func print_gui_input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		print(event)
	pass

func _input(event):
	if event is InputEventMouseButton:
#		print(song_time_cursor)
		pass
	if event is InputEventMouseMotion and Input.is_key_pressed(KEY_CONTROL):
		if in_enemy_track:
			get_tree().call_group("Audio Stream Recievers", "scrub_enemy_audio", song_time_transform(get_global_mouse_position().y))
		if in_player_track:
			get_tree().call_group("Audio Stream Recievers", "scrub_player_audio", song_time_transform(get_global_mouse_position().y))
		pass
	if event.is_action_pressed("copy"):
		copy_notes()
#		get_tree().call_group("Note Clipboard Recievers", "recieve_")
	if event.is_action_pressed("paste"):
		get_tree().call_group("Track Input Recievers", "recieve_mouse_over_player_track", in_player_track)
		paste_notes()
	if event.is_action_pressed("select_all"):
		get_tree().call_group("Track Input Recievers", "recieve_select_all")
	if event.is_action_pressed("delete"):
#		get_tree().call_group("Track Input Recievers", "recieve_delete_selected")
		var notes = get_tree().get_nodes_in_group("Selected Notes")
		for note in notes:
			note.delete()

func copy_notes():
	var notes = get_tree().get_nodes_in_group("Selected Notes")
	note_clipboard = []
	for note in notes:
		var note_data = note.get_data()
		var index = note_clipboard.bsearch_custom(note_data[0], Note.NoteDataSorter, "search_hit_time")
		note_clipboard.insert(index,note_data)
#		note.selected = false
#		note_clipboard.append(note.get_data())
#		print(note.editor_note_type)
		pass

func paste_notes():
	get_tree().call_group("Note Clipboard Recievers", "recieve_paste_notes", note_clipboard)

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

func recieve_song_time(time):
	song_time = time

func recieve_bpm(tempo):
	bpm = tempo

func recieve_snapping_offset(offset):
	snapping_offset = offset

func recieve_visible_positions(v_pos_0, v_pos_1):
	var v_time_0 = song_time_transform(v_pos_0)
	var v_time_1 = song_time_transform(v_pos_1)
	get_tree().call_group("Track Visibility Recievers", "recieve_visible_times", v_time_0, v_time_1)
	pass

func recieve_song_playing(playing):
	if playing:
		self.transform_mode = 3
	else:
		self.transform_mode = 0

func recieve_chart_data(chart_data):
	if "player_audio" in chart_data:
		_on_Player_Vocals_File_Dialog_file_selected(chart_data["player_audio"])
		pass
	if "instrumentals_audio" in chart_data:
		_on_Instrumentals_File_Dialog_file_selected(chart_data["instrumentals_audio"])
		pass
	if "enemy_audio" in chart_data:
		_on_FileDialog_file_selected(chart_data["enemy_audio"])
	if "bpm" in chart_data:
		self.bpm = chart_data["bpm"]
	if "snapping_offset" in chart_data:
		self.snapping_offset = chart_data["snapping_offset"]
	pass

func recieve_paste_notes():
	paste_notes()

func recieve_copy_notes():
	copy_notes()

func send_chart_data(chart_data):
	chart_data["bpm"] = bpm
	chart_data["snapping_offset"] = snapping_offset
	pass

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
#	$Popups/FileDialog.popup()
	$"Popups/Enemy Vocals File Dialog".popup()
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	var thingy = ChartEditor.new()
	var stream = thingy.load_wav_file(path)
	get_tree().call_group("Audio Stream Recievers", "recieve_enemy_audio_stream", stream)
	get_tree().call_group("Audio Stream Recievers", "recieve_enemy_audio_path", path)
	pass # Replace with function body.


func _on_Instumental_Track_Input_Area_mouse_exited():
	transform_mode = 0
	pass # Replace with function body.


func _on_Import_Chart_Button_pressed():
	$"Popups/Import Chart Dialouge".popup()
	pass # Replace with function body.


func _on_Import_Chart_Dialouge_file_selected(path):
	get_tree().call_group("Chart File Recievers", "recieve_chart_file", path)
	pass # Replace with function body.


func _on_Shapping_Button_toggled(button_pressed):
	snapping = button_pressed
	pass # Replace with function body.


func _on_BPM_Edit_text_entered(new_text):
	if new_text.is_valid_float() and float(new_text) > 0.0:
		self.bpm = float(new_text)
	pass # Replace with function body.


func _on_Snapping_Offset_Edit_text_entered(new_text):
	if new_text.is_valid_float():
		self.snapping_offset = float(new_text)
	pass # Replace with function body.


func _on_Grid_Button_toggled(button_pressed):
	$"Main UI/Track UI/Snapping Grid".visible = button_pressed
	pass # Replace with function body.

var hide_enemy_waveform = false
func _on_enemy_waveform_hide():
	hide_enemy_waveform = !hide_enemy_waveform
	get_tree().call_group("Audio Stream Recievers", "recieve_enemy_waveform_hide", hide_enemy_waveform)
	pass # Replace with function body.


func _on_Button3_pressed():
	$"Popups/Enemy Volume Popup".popup()
	pass # Replace with function body.


func _on_Enemy_Volume_Slider_value_changed(value):
	get_tree().call_group("Audio Stream Recievers", "recieve_enemy_volume", value)
	pass # Replace with function body.


func _on_Instrumentals_File_Dialog_file_selected(path):
	var thingy = ChartEditor.new()
	var stream = thingy.load_wav_file(path)
	get_tree().call_group("Audio Stream Recievers", "recieve_instrumentals_audio_stream", stream)
	get_tree().call_group("Audio Stream Recievers", "recieve_instrumentals_audio_path", path)
	pass # Replace with function body.


func _on_Player_Vocals_File_Dialog_file_selected(path):
	var thingy = ChartEditor.new()
	var stream = thingy.load_wav_file(path)
	get_tree().call_group("Audio Stream Recievers", "recieve_player_audio_stream", stream)
	get_tree().call_group("Audio Stream Recievers", "recieve_player_audio_path", path)
	pass
	pass # Replace with function body.


func _on_load_instrumentals():
	$"Popups/Instrumentals File Dialog".popup()
	pass # Replace with function body.

var hide_instrumentals_waveform = false
func _on_instrumentals_waveform_hide():
	hide_instrumentals_waveform = !hide_instrumentals_waveform
	get_tree().call_group("Audio Stream Recievers", "recieve_instrumentals_waveform_hide", hide_instrumentals_waveform)
	pass # Replace with function body.


func _on_Instrumentals_Volume_Slider_value_changed(value):
	get_tree().call_group("Audio Stream Recievers", "recieve_instrumentals_volume", value)
	pass # Replace with function body.


func _on_instrumentals_volume_button_pressed():
	$"Popups/Instrumentals Volume Popup".popup()
	pass # Replace with function body.


func _on_load_player_vocals_button_pressed():
	$"Popups/Player Vocals File Dialog".popup()
	pass # Replace with function body.


#func _on_player_waveform_hide_pressed():
#	pass # Replace with function body.

var hide_player_waveform = false
func _on_player_waveform_hide():
	hide_player_waveform = !hide_player_waveform
	get_tree().call_group("Audio Stream Recievers", "recieve_player_waveform_hide", hide_player_waveform)
	pass # Replace with function body.


func _on_Player_Volume_Slider_value_changed(value):
	get_tree().call_group("Audio Stream Recievers", "recieve_player_volume", value)
	pass # Replace with function body.


func _on_player_volume_button_pressed():
	$"Popups/Player Volume Popup".popup()
	pass # Replace with function body.


func _on_Exit_Button_pressed():
	$"Popups/Exit Confirm".popup()
	pass # Replace with function body.


func _on_Exit_Confirm_confirmed():
	get_tree().change_scene("res://assets/scenes/Menu Screens.tscn")
	pass # Replace with function body.

var in_enemy_track = false
func _on_Enemy_Input_Area_mouse_entered():
	in_enemy_track = true
	in_player_track = false
	get_tree().call_group("Track Input Recievers", "recieve_mouse_over_player_track", in_player_track)
	pass # Replace with function body.

var in_player_track = false
func _on_Player_Input_Area_mouse_entered():
	in_player_track = true
	in_enemy_track = false
	get_tree().call_group("Track Input Recievers", "recieve_mouse_over_player_track", in_player_track)
	pass # Replace with function body.


func _on_LinkButton_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=x_dP_EWLANI")
	pass # Replace with function body.


func _on_Playback_Speed_Edit_text_entered(new_text):
	if new_text.is_valid_float():
		var n_speed = float(new_text)/100.0
		get_tree().call_group("Audio Stream Recievers", "set_playback_speed", n_speed)
	pass # Replace with function body.
