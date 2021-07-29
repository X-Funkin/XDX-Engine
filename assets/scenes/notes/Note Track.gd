extends Node2D
class_name ArrowTrack

export(String, FILE) var chart_file
export(int, "XDX", "FNF", "KADE") var chart_format
export(int) var chart_channel
export(bool) var player_track
export(float) var scroll_speed = 1.0 setget set_scroll_speed, get_scroll_speed
var song_time : float = 0.0
var notes = []

#export(PackedScene) var left_note
#export(PackedScene) var down_note
#export(PackedScene) var up_note
#export(PackedScene) var right_note

var left_note : PackedScene = preload("res://assets/scenes/notes/Left Note.tscn")
var down_note : PackedScene = preload("res://assets/scenes/notes/Down Note.tscn")
var up_note : PackedScene = preload("res://assets/scenes/notes/Up Note.tscn")
var right_note : PackedScene = preload("res://assets/scenes/notes/Right Note.tscn")

var left_note_track : NodePath = @"Left Track/Left Arrow/Left Notes Transform/Left Notes"
var down_note_track : NodePath = @"Down Track/Down Arrow/Down Notes Transform/Down Notes"
var up_note_track : NodePath = @"Up Track/Up Arrow/Up Notes Transform/Up Notes"
var right_note_track : NodePath = @"Right Track/Right Arrow/Right Notes Transform/Right Notes"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#setter/gattors bois

func set_scroll_speed(n_speed):
	scroll_speed = n_speed
	get_node(left_note_track).get_parent().scale.y = scroll_speed
	get_node(down_note_track).get_parent().scale.y = scroll_speed
	get_node(up_note_track).get_parent().scale.y = scroll_speed
	get_node(right_note_track).get_parent().scale.y = scroll_speed
	for note in notes:
		note.scale.y = 1.0/scroll_speed

func get_scroll_speed():
	return scroll_speed

#Chart Importer Functions lol
func import_chart():
	pass

func import_fnf_chart():
	var file = File.new()
	file.open(chart_file, File.READ)
	var chart_data = JSON.parse(file.get_as_text()).result
	if player_track:
		for note_section in chart_data["song"]["notes"]:
			if note_section["mustHitSection"]:
				for note in note_section["sectionNotes"]:
					if note[1] < 4:
						import_note(note)
			else:
				for note in note_section["sectionNotes"]:
					if note[1] > 3:
						import_note(note)
	else:
		for note_section in chart_data["song"]["notes"]:
			if note_section["mustHitSection"]:
				for note in note_section["sectionNotes"]:
					if note[1] > 3:
						import_note(note)
			else:
				for note in note_section["sectionNotes"]:
					if note[1] < 4:
						import_note(note)
	notes = get_notes(true)

func import_kade_chart():
	pass


func import_note(note_data):
	var note : Note = null
	var track = null
	match int(note_data[1])%4:
		0:
			note = left_note.instance()
			track = left_note_track
		1:
			note = down_note.instance()
			track = down_note_track
		2:
			note = up_note.instance()
			track = up_note_track
		3:
			note = right_note.instance()
			track = right_note_track
	note.hit_time = note_data[0]
	note.hold_time = note_data[2]
	if len(note_data) > 3:
		note.custom_data = note_data[3]
	get_node(track).add_child(note)
	note.position.y = note.hit_time
	note.scale.y = 1.0/scroll_speed

func load_chart():
	match chart_format:
		0:
			import_chart()
		1:
			import_fnf_chart()
		2:
			import_kade_chart()

#Note Getterrrs
func get_left_notes():
	return get_node(left_note_track).get_children()

func get_down_notes():
	return get_node(down_note_track).get_children()

func get_up_notes():
	return get_node(up_note_track).get_children()

func get_right_notes():
	return get_node(right_note_track).get_children()

func get_notes(sorted=false):
	var note_arr = []
	note_arr.append_array(get_left_notes())
	note_arr.append_array(get_down_notes())
	note_arr.append_array(get_up_notes())
	note_arr.append_array(get_right_notes())
	if sorted:
		note_arr.sort_custom(Note.NoteSorter, "sort_hit_time")
	return note_arr
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recieve_song_time(n_time):
	song_time = n_time
	get_node(left_note_track).song_time = n_time
	get_node(down_note_track).song_time = n_time
	get_node(up_note_track).song_time = n_time
	get_node(right_note_track).song_time = n_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
