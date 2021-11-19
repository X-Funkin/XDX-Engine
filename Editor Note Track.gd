extends NoteTrack
class_name EditorNoteTrack


export(float) var song_cursor



var editor_left_note : PackedScene = preload("res://assets/scenes/notes/Editor Left Note.tscn")
var editor_down_note : PackedScene = preload("res://assets/scenes/notes/Editor Down Note.tscn")
var editor_up_note : PackedScene = preload("res://assets/scenes/notes/Editor Up Note.tscn")
var editor_right_note : PackedScene = preload("res://assets/scenes/notes/Editor Right Note.tscn")


var editor_left_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Left Hold Note.tscn")
var editor_down_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Down Hold Note.tscn")
var editor_up_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Up Hold Note.tscn")
var editor_right_hold_note : PackedScene = preload("res://assets/scenes/notes/Editor Right Hold Note.tscn")




func import_hold_note(note_data, player_note = false):
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
	var note_index = notes.bsearch_custom(note.hit_time,Note.NoteSorter,"search_hit_time")
	notes.insert(note_index,note)
	note.editor_note_type = int(player_note)
	get_tree().call_group("Track Note Recievers", "recieve_track_notes", self, notes)
	note.set_process(false)

func import_note(note_data, player_note=false):
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
	var note_index = notes.bsearch_custom(note.hit_time,Note.NoteSorter,"search_hit_time")
	notes.insert(note_index,note)
	get_tree().call_group("Track Note Recievers", "recieve_track_notes", self, notes)
	note.set_process(false)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func recieve_chart_file(path):
	chart_file = path
	if path.split(".")[-1] == "json":
		import_fnf_chart()
	elif path.split(".")[-1] == "osu":
		print("OSU CHART")
		import_osu_chart()
#	notes = get_notes(true)
	for note_i in range(notes.size()):
		var thingy = float(note_i)/notes.size()
		notes[note_i].modulate = Color.from_hsv(thingy,1,1,1)

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
				closest_note.queue_free()
				note_data[2] = abs(closest_note.hit_time - song_time)
				import_hold_note(note_data)

func recieve_song_time_cursor(time):
	song_cursor = time

func recieve_zoom(zoom):
	self.scroll_speed = zoom

func recieve_track_input(track_type, lane_type, event):
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

func recieve_enemy_hit(note, hit_error):
	if int(player_track) == note.editor_note_type:
		print("yeah baoybe ", player_track, " ", note.editor_note_type, " ", note.note_type)
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
