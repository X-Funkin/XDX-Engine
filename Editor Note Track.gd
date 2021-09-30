extends NoteTrack
class_name EditorNoteTrack


export(float) var song_cursor



var editor_left_note : PackedScene = preload("res://assets/scenes/notes/Editor Left Note.tscn")
var editor_down_note : PackedScene = preload("res://assets/scenes/notes/Editor Down Note.tscn")
var editor_up_note : PackedScene = preload("res://assets/scenes/notes/Editor Up Note.tscn")
var editor_right_note : PackedScene = preload("res://assets/scenes/notes/Editor Right Note.tscn")


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
	note.player_note = player_note
	notes = get_notes()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recieve_song_time_cursor(time):
	song_cursor = time

func recieve_zoom(zoom):
	self.scroll_speed = zoom

func recieve_track_input(track_type, lane_type, event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if int(player_track) == track_type:
				import_note([song_cursor,lane_type,0])
				pass
		pass
	if int(player_track) == track_type:
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
