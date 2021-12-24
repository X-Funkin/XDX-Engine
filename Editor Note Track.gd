extends NoteTrack
class_name EditorNoteTrack


export(String) var track_name
export(float) var song_cursor
export(float) var cursor_time
export(int, "Select", "Note") var editor_mode
export(bool) var hover_over #setget set_hover_over

func set_hover_over(n_hover):
	hover_over = n_hover
	if hover_over:
		modulate = Color.black
	else:
		modulate = Color.white

var undo_array = []
var op_cache = []
var redo_array = []

var editor_left_note : PackedScene = preload("res://assets/scenes/notes/Editor Left Note.tscn")
var editor_down_note : PackedScene = preload("res://assets/scenes/notes/Editor Down Note.tscn")
var editor_up_note : PackedScene = preload("res://assets/scenes/notes/Editor Up Note.tscn")
var editor_right_note : PackedScene = preload("res://assets/scenes/notes/Editor Right Note.tscn")


var editor_left_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Left Hold Note.tscn")
var editor_down_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Down Hold Note.tscn")
var editor_up_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Up Hold Note.tscn")
var editor_right_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Right Hold Note.tscn")

var editor_note_click_area : PackedScene = preload("res://assets/scenes/notes/Editor Note Click Area.tscn")


func import_hold_note(note_data, player_note = false, cache_op=true):
	var note : EditorHoldNote = null
	var track = null
	match int(note_data[1])%4:
		0:
			note = editor_left_hold_note.instance()
			track = left_note_track
		1:
			note = editor_down_hold_note.instance()
			track = down_note_track
		2:
			note = editor_up_hold_note.instance()
			track = up_note_track
		3:
			note = editor_right_hold_note.instance()
			track = right_note_track
	note.hit_time = note_data[0]
	note.hold_note = (note_data[2] > 0.0)
	note.hold_time = note_data[2]
	if len(note_data) > 3:
		note.custom_data = note_data[3]
	get_node(track).add_child(note)
	note.position.y = note.hit_time
	note.scale.y = 1.0/scroll_speed
	note.player_note = (player_note and false)
	note.update_scale()
#	notes = get_notes()
#	var note_index = notes.bsearch_custom(note.hit_time,Note.NoteSorter,"search_hit_time")
#	notes.insert(note_index,note)
	list_note(note)
	note.editor_note_type = int(player_note)
	get_tree().call_group("Track Note Recievers", "recieve_track_notes", self, notes)
	note.set_process(false)
	if cache_op:
		op_cache.append([0, note.get_data(), note])
	return note

func import_note(note_data, player_note=false, cache_op=true):
	var note : EditorNote = null
	var track = null
	match int(note_data[1])%4:
		0:
			note = editor_left_note.instance()
			track = left_note_track
		1:
			note = editor_down_note.instance()
			track = down_note_track
		2:
			note = editor_up_note.instance()
			track = up_note_track
		3:
			note = editor_right_note.instance()
			track = right_note_track
	note.hit_time = note_data[0]
	note.hold_note = (note_data[2] > 0.0)
	note.hold_time = note_data[2]
	if len(note_data) > 3:
		note.custom_data = note_data[-1]
	get_node(track).add_child(note)
	note.position.y = note.hit_time
	note.scale.y = 1.0/scroll_speed
	note.player_note = (player_note and false)
	note.editor_note_type = int(player_note)
#	notes = get_notes()
#	var note_index = notes.bsearch_custom(note.hit_time,Note.NoteSorter,"search_hit_time")
#	notes.insert(note_index,note)
	list_note(note)
	get_tree().call_group("Track Note Recievers", "recieve_track_notes", self, notes)
	note.set_process(false)
	if cache_op:
		op_cache.append([0,note.get_data(),note])
	return note

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func recieve_chart_file(path):
	chart_file = path
	match path.split(".")[-1]:
		"json":
			import_fnf_chart()
		"osu":
			print("OSU CHART")
			import_osu_chart()
		"chart":
			pass
#	notes = get_notes(true)
#	for note_i in range(notes.size()):
#		var thingy = float(note_i)/notes.size()
#		notes[note_i].modulate = Color.from_hsv(thingy,1,1,1)

func list_note(note):
	var note_index = notes.bsearch_custom(note.hit_time,Note.NoteSorter,"search_hit_time")
	notes.insert(note_index,note)

func unlist_note(note):
	var search_index = search_hit_time(note.hit_time-50.0)
	var note_index = notes.find(note,search_index)
	if note_index != -1:
		notes.remove(note_index)
		pass
#	var note_index = notes.bsearch_custom(note.hit_time,Note.NoteSorter,"search_hit_time")
#	notes.erase()

func delete_note(note, cache_op=true):
	var search_index = search_hit_time(note.hit_time-50.0)
	var note_index = notes.find(note,search_index)
	if note_index != -1:
		var del_note = notes.pop_at(note_index)
		if cache_op:
			op_cache.append([1,del_note.get_data(),del_note])
#		del_note.queue_free()
		del_note.get_parent().remove_child(del_note)

func remove_note(note,cache_op=true):
	pass

func clear_notes():
	for note in notes:
#		note.delete()
		unlist_note(note)
		delete_note(note)

func add_note(note):
	var target_track = null
	match note.note_type:
		0:
			target_track = left_note_track
		1:
			target_track = down_note_track
		2:
			target_track = up_note_track
		3:
			target_track = right_note_track
	if target_track:
		get_node(target_track).add_child(note)
		list_note(note)
		self.scroll_speed = scroll_speed

func select_notes(to_note):
	var selected_notes = get_tree().get_nodes_in_group("Selected Notes")
	if selected_notes != []:
		var first_note = selected_notes[0]
		var from_hit_time = first_note.hit_time
		var to_hit_time = to_note.hit_time
		var start_index = search_hit_time(from_hit_time)
		var end_index = search_hit_time(to_hit_time)
		for index in range(start_index, end_index):
			notes[index].selected = true
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_hold_note(song_time, lane_type):
	var notes = []
	match lane_type:
		0:
			notes = get_left_notes()
		1:
			notes = get_down_notes()
		2:
			notes = get_up_notes()
		3:
			notes = get_right_notes()
	if notes != []:
		var closest_note = notes[0]
		for note in notes:
			if note.hit_time < song_time and note.hit_time > closest_note.hit_time:
				closest_note = note
				pass
			pass
		if closest_note.hit_time < song_time:
			if closest_note.hold_note:
				closest_note.hold_time = abs(closest_note.hit_time - song_time)
				closest_note.update_scale()
			else:
				var note_data = closest_note.get_data()
				closest_note.delete()
				note_data[2] = abs(closest_note.hit_time - song_time)
				import_hold_note(note_data, player_track)


func update_note_click_areas():
	cursor_time = ($"Down Track/Down Arrow/Down Notes Transform/Down Notes".global_transform.affine_inverse()*get_global_mouse_position()).y
	var start_time = cursor_time-250.0
	var end_time = cursor_time+250.0
	var start_index = search_hit_time(start_time)
	var end_index = search_hit_time(end_time)
#	print("yup noting the notes here don't mind me")
	for i in range(start_index,end_index):
#		print("oh wouldya look at that, the %sth note on the list"%i)
		var note = notes[i]
#		print("yeah i know a ", note, " when i see it")
		var click_area = note.get_node_or_null(note.click_area)
		if click_area == null and abs(note.hit_time-cursor_time) < 1000.0:
			
#			print("this one right here doesn't seem to have a click area, hmmm")
			click_area = editor_note_click_area.instance()
			note.add_child(click_area)
			click_area.note_track = self.get_path()
			click_area.note = note.get_path()
			note.click_area = click_area.get_path()
			click_area.song_time = note.hit_time
	
	pass

#func _input(event):
#	if event is InputEventMouseMotion

func recieve_song_time_cursor(time):
	song_cursor = time
	update_note_click_areas()

#func recieve_cursor(pos):
#	pass

func recieve_zoom(zoom):
	self.scroll_speed = zoom

func recieve_track_input(track_type, lane_type, event):
	match editor_mode:
		0:
			pass
		1:
			if event is InputEventMouseButton:
				if event.is_pressed() and event.button_index == BUTTON_LEFT and Input.is_key_pressed(KEY_SHIFT):
					if int(player_track) == track_type:
						add_hold_note(song_cursor,lane_type)
				elif event.is_pressed() and event.button_index == BUTTON_LEFT:
					if int(player_track) == track_type:
						import_note([song_cursor,lane_type,0], player_track)
						pass
				pass
			if int(player_track) == track_type:
				pass
			pass

func recieve_mouse_over_player_track(is_in_player_track):
	if is_in_player_track == player_track:
		self.hover_over = true
	else:
		self.hover_over = false
	pass

func recieve_enemy_hit(note, hit_error):
	if int(player_track) == note.editor_note_type:
#		print("yeah baoybe ", player_track, " ", note.editor_note_type, " ", note.note_type)
		match note.note_type:
			0:
				get_node(left_arrow).play_confirm_tap()
			1:
				get_node(down_arrow).play_confirm_tap()
			2:
				get_node(up_arrow).play_confirm_tap()
			3:
				get_node(right_arrow).play_confirm_tap()
		pass
	pass

func recieve_delete_note(note):
	delete_note(note)

func recieve_editor_mode(mode):
	editor_mode = mode

func recieve_paste_notes(note_clipboard):
	if hover_over:
		if note_clipboard != []:
			var clipboard_start = note_clipboard[0]
			for note_data in note_clipboard:
				var new_note_data = note_data.duplicate(true)
				new_note_data[0] = note_data[0]-clipboard_start[0]+song_cursor
				if note_data[2] > 0.0:
					import_hold_note(new_note_data,player_track)
				else:
					import_note(new_note_data,player_track)
				pass
	pass

func recieve_select_all():
	for note in notes:
		note.selected = true

func recieve_mirror_notes():
	var notes = get_tree().get_nodes_in_group("Selected Notes")
	for note in notes:
		if note.editor_note_type == int(player_track):
			var note_data = note.get_data()
			match note_data[1]:
				0:
					note_data[1] = 3
				1:
					note_data[1] = 2
				2:
					note_data[1] = 1
				3:
					note_data[1] = 0
				
			if note_data[2] > 0.0:
				import_hold_note(note_data,player_track)
			else:
				import_note(note_data,player_track)
			delete_note(note)

func recieve_swap_notes_array(swap_array):
	var notes = get_tree().get_nodes_in_group("Selected Notes")
	for note in notes:
		if note.editor_note_type == int(player_track):
			var note_data = note.get_data()
			note_data[1] = swap_array[note_data[1]]
			if note_data[2] > 0.0:
				import_hold_note(note_data,player_track)
			else:
				import_note(note_data,player_track)
			delete_note(note)
	pass

func send_chart_data(chart_data : Dictionary):
	var note_array = get_notes()
	var note_data_array = []
	for note in notes:
		note_data_array.append(note.get_data())
	chart_data[track_name] = note_data_array

func recieve_chart_data(chart_data : Dictionary):
	if track_name in chart_data:
		clear_notes()
		for note in chart_data[track_name]:
			if note[2] > 0:
				import_hold_note(note, player_track)
			else:
				import_note(note, player_track)

func undo():
	var op = undo_array.pop_back()
#	print("UNDO OP ", op)
	var r_op = []
	if op != null:
		for thing in op:
			if thing[1] is Object:
				if !is_instance_valid(thing[1]):
					op.erase(thing)
					continue
#				return 0
#			else:
			match thing[0]:
				0:
					r_op.append([0,thing[1],thing[2]])
					delete_note(thing[2],false)
					pass
				1:
					add_note(thing[2])
					r_op.append([1,thing[1],thing[2]])
#					if thing[1][2] > 0:
#						var note = import_hold_note(thing[1], player_track, false)
#						r_op.append([1,note])
#					else:
#						var note = import_note(thing[1], player_track, false)
#						r_op.append([1,note])
		if r_op != []:
			redo_array.append(r_op)
	pass

func redo():
	var op = redo_array.pop_back()
#	print("REDO OP ", op)
	var u_op = []
	if op != null:
		for thing in op:
			match thing[0]:
				0:
					add_note(thing[2])
					u_op.append([0,thing[1],thing[2]])
#					if thing[1][2] > 0:
#						var note = import_hold_note(thing[1], player_track, false)
#						u_op.append([0,note])
#						thing[2]=note
#					else:
#						var note = import_note(thing[1], player_track, false)
#						u_op.append([0,note])
##						thing[2]=note
				1:
					u_op.append([1,thing[1],thing[2]])
					delete_note(thing[2],false)
		undo_array.append(u_op)

#func recieve_delete_selected

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if op_cache != []:
#		print("OPERATIONBS HAVE BEEN MAAADEEEE")
		yield(get_tree(),"idle_frame")
#		print("ONE FRAME LATERRRR")
#		print("OP CACHE ", op_cache)
		undo_array.append(op_cache)
		op_cache = []
		redo_array = []
#		print("UNDO ARRRRRAYYY ", undo_array)
#		print("REDO ARRRRRAYYY ", redo_array)
#		UndoRedo
		pass
#	pass

func _input(event):
	if event.is_action_pressed("undo") and !Input.is_key_pressed(KEY_SHIFT):
		if hover_over:
#			print("\n\nUNDO\n")
			undo()
#			print("UNDO ARRRRRAYYY ", undo_array)
#			print("REDO ARRRRRAYYY ", redo_array)
		pass
	if event.is_action_pressed("redo"):
		if hover_over:
#			print("\n\nREDO\n")
			redo()
#			print("UNDO ARRRRRAYYY ", undo_array)
#			print("REDO ARRRRRAYYY ", redo_array)
