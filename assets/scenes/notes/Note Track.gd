extends Node2D
class_name NoteTrack


# Export very ables mm yes
export(String, FILE) var chart_file
export(int, "XDX", "FNF", "OSU") var chart_format
export(int) var chart_channel
export(bool) var player_track
export(float) var scroll_speed = 1.0 setget set_scroll_speed, get_scroll_speed
export(float) var timing_window = 120.0
var song_time : float = 0.0
var notes : Array = []

#export(PackedScene) var left_note
#export(PackedScene) var down_note
#export(PackedScene) var up_note
#export(PackedScene) var right_note

var left_note : PackedScene = preload("res://assets/scenes/notes/Left Note.tscn")
var down_note : PackedScene = preload("res://assets/scenes/notes/Down Note.tscn")
var up_note : PackedScene = preload("res://assets/scenes/notes/Up Note.tscn")
var right_note : PackedScene = preload("res://assets/scenes/notes/Right Note.tscn")

var left_hold_note : PackedScene = preload("res://assets/scenes/notes/Left Hold Note.tscn")
var down_hold_note : PackedScene = preload("res://assets/scenes/notes/Down Hold Note.tscn")
var up_hold_note : PackedScene = preload("res://assets/scenes/notes/Up Hold Note.tscn")
var right_hold_note : PackedScene = preload("res://assets/scenes/notes/Right Hold Note.tscn")


var left_note_track : NodePath = @"Left Track/Left Arrow/Left Notes Transform/Left Notes"
var down_note_track : NodePath = @"Down Track/Down Arrow/Down Notes Transform/Down Notes"
var up_note_track : NodePath = @"Up Track/Up Arrow/Up Notes Transform/Up Notes"
var right_note_track : NodePath = @"Right Track/Right Arrow/Right Notes Transform/Right Notes"

var left_arrow : NodePath = @"Left Track/Left Arrow"
var down_arrow : NodePath = @"Down Track/Down Arrow"
var up_arrow : NodePath = @"Up Track/Up Arrow"
var right_arrow : NodePath = @"Right Track/Right Arrow"

var left_timer : NodePath = @"Left Track/Left Arrow/Auto Input Timer"
var down_timer : NodePath = @"Down Track/Down Arrow/Auto Input Timer"
var up_timer : NodePath = @"Up Track/Up Arrow/Auto Input Timer"
var right_timer : NodePath = @"Right Track/Right Arrow/Auto Input Timer"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#setter/gattors bois

func set_scroll_speed(n_speed):
	scroll_speed = n_speed
	if not is_inside_tree(): yield(self, 'ready')
	get_node(left_note_track).get_parent().scale.y = scroll_speed
	get_node(down_note_track).get_parent().scale.y = scroll_speed
	get_node(up_note_track).get_parent().scale.y = scroll_speed
	get_node(right_note_track).get_parent().scale.y = scroll_speed
	for note in notes:
#		print(typeof(note))
		
		if note == null or !is_instance_valid(note):
			print("NULL NOTE")
			notes.erase(note)
			continue
		note.scale.y = 1.0/scroll_speed
		if note.hold_note:
			note.update_scale()
#			get_node(note.hold_note_body).scale.y = scroll_speed
#			get_node(note.hold_note_end).scale.y = 1.0/get_node(note.hold_note_body).scale.y

func get_scroll_speed():
	return scroll_speed

#Chart Importer Functions lol
func import_chart():
	pass

func import_fnf_chart():
	clear_notes()
	var file = File.new()
	file.open(chart_file, File.READ)
	var chart_data = JSON.parse(file.get_as_text()).result
	if player_track:
		for note_section in chart_data["song"]["notes"]:
			if note_section["mustHitSection"]:
				for note in note_section["sectionNotes"]:
					if note[1] < 4:
						if note[2] > 0.0:
							import_hold_note(note, true)
						else:
							import_note(note, true)
			else:
				for note in note_section["sectionNotes"]:
					if note[1] > 3:
						if note[2] > 0.0:
							import_hold_note(note, true)
						else:
							import_note(note, true)
	else:
		for note_section in chart_data["song"]["notes"]:
			if note_section["mustHitSection"]:
				for note in note_section["sectionNotes"]:
					if note[1] > 3:
						if note[2] > 0.0:
							import_hold_note(note)
						else:
							import_note(note)
			else:
				for note in note_section["sectionNotes"]:
					if note[1] < 4:
						if note[2] > 0.0:
							import_hold_note(note)
						else:
							import_note(note)
	notes = get_notes(true)
	var n_index = 0
	for note in notes:
		note.note_index = n_index
		n_index+=1

func import_osu_chart():
	clear_notes()
	print("IMPORTING OSU CHART")
	var file = File.new()
	file.open(chart_file, File.READ)
	var data_string = file.get_as_text()
	var data_parse_array = data_string.split("\n")
	var decyphering_data = false
	var index_thingy = []
	for data_line in data_parse_array:
#		print(data_line)
		if !decyphering_data:
			if data_line == "[HitObjects]":
#				print("FOUND HIT OBJECTS")
				decyphering_data = true
			continue
		var data_string_array : PoolStringArray = (data_line.split(":")[0]).split(",")
		var data_array = [0,0,0]
		if data_string_array.size() > 3:
			data_array[0] = int(data_string_array[2])
#			if !int(data_string_array[0]) in index_thingy:
#				index_thingy.append(int(data_string_array[0]))
#				index_thingy.sort()
			match int(data_string_array[0]):
				64:
					data_array[1] = 0
				192:
					data_array[1] = 1
				320:
					data_array[1] = 2
				448:
					data_array[1] = 3
				_:
					continue
			if int(data_string_array[5]) > 0:
				data_array[2] = int(data_string_array[5])-data_array[0]
#			print(data_array)
			if data_array[2] != 0:
				import_hold_note(data_array, player_track)
			else:
				import_note(data_array,player_track)
			pass
#	data_string.lstrip()

#func import_kade_chart():
#	pass


func import_note(note_data, player_note=false):
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
	note.hold_note = (note_data[2] > 0.0)
	note.hold_time = note_data[2]
	if len(note_data) > 3:
		note.custom_data = note_data[-1]
	get_node(track).add_child(note)
	note.position.y = note.hit_time
	note.scale.y = 1.0/scroll_speed
	note.player_note = player_note
	note.set_process(false)

func import_hold_note(note_data, player_note = false):
	var note : HoldNote = null
	var track = null
	match int(note_data[1])%4:
		0:
			note = left_hold_note.instance()
			track = left_note_track
		1:
			note = down_hold_note.instance()
			track = down_note_track
		2:
			note = up_hold_note.instance()
			track = up_note_track
		3:
			note = right_hold_note.instance()
			track = right_note_track
	note.hit_time = note_data[0]
	note.hold_note = (note_data[2] > 0.0)
	note.hold_time = note_data[2]
	if len(note_data) > 3:
		note.custom_data = note_data[3]
	get_node(track).add_child(note)
	note.position.y = note.hit_time
	note.scale.y = 1.0/scroll_speed
	note.player_note = player_note
	note.update_scale()
	note.set_process(false)

func load_chart():
	match chart_format:
		0:
			import_chart()
		1:
			import_fnf_chart()
		2:
			import_osu_chart()
	notes = get_notes(true)

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

func search_hit_time(hit_time):
	return notes.bsearch_custom(hit_time,Note.NoteSorter,"search_hit_time")

func update_notes():
	var start_index = search_hit_time(song_time-50.0)
	var end_index = search_hit_time(song_time+1000.0)
	for i in range(start_index,end_index):
		notes[i].set_process(true)

func clear_notes():
#	notes.empty()
	for note in notes:
		note.queue_free()
	notes.clear()

func signal_self():
	get_tree().call_group("Note Track Recievers", "recieve_note_track", self)

#funky input stuff
func recieve_player_left_input(event : InputEvent):
	if player_track:
		if event.is_pressed():
			get_node(left_arrow).play_press()
			if get_node(left_note_track).holding_note:
				get_node(left_note_track).held_note.playing = true
		else:
			get_node(left_arrow).play_default()
			print("left note up lol")
			if get_node(left_note_track).holding_note:
				print("yeah it's got a hold note baybeee")
				get_node(left_note_track).held_note.playing = false
				get_tree().call_group("Player Miss Recievers", "recieve_player_miss", 0)
		pass

func recieve_player_down_input(event : InputEvent):
	if player_track:
		if event.is_pressed():
			get_node(down_arrow).play_press()
			if get_node(down_note_track).holding_note:
				get_node(down_note_track).held_note.playing = true
		else:
			get_node(down_arrow).play_default()
			if get_node(down_note_track).holding_note:
				get_node(down_note_track).held_note.playing = false
				get_tree().call_group("Player Miss Recievers", "recieve_player_miss", 1)
		pass

func recieve_player_up_input(event : InputEvent):
	if player_track:
		if event.is_pressed():
			get_node(up_arrow).play_press()
			if get_node(up_note_track).holding_note:
				get_node(up_note_track).held_note.playing = true
		else:
			get_node(up_arrow).play_default()
			if get_node(up_note_track).holding_note:
				get_node(up_note_track).held_note.playing = false
				get_tree().call_group("Player Miss Recievers", "recieve_player_miss", 2)
		pass

func recieve_player_right_input(event : InputEvent):
	if player_track:
		if event.is_pressed():
			get_node(right_arrow).play_press()
			if get_node(right_note_track).holding_note:
				get_node(right_note_track).held_note.playing = true
		else:
			get_node(right_arrow).play_default()
			if get_node(right_note_track).holding_note:
				get_node(right_note_track).held_note.playing = false
				get_tree().call_group("Player Miss Recievers", "recieve_player_miss", 3)
		pass

func recieve_player_hit(note : Note, hit_error):
	if player_track:
		match note.note_type:
			0:
				get_node(left_arrow).play_confirm()
				if note.hold_note:
					get_node(left_arrow).play_confirm_loop()
			1:
				get_node(down_arrow).play_confirm()
				if note.hold_note:
					get_node(down_arrow).play_confirm_loop()
			2:
				get_node(up_arrow).play_confirm()
				if note.hold_note:
					get_node(up_arrow).play_confirm_loop()
			3:
				get_node(right_arrow).play_confirm()
				if note.hold_note:
					get_node(right_arrow).play_confirm_loop()
			


func recieve_enemy_left_input(event : InputEvent):
	if !player_track:
		if event.is_pressed():
			get_node(left_arrow).play_press()
		else:
			get_node(left_arrow).play_default()
		pass

func recieve_enemy_down_input(event : InputEvent):
	if !player_track:
		if event.is_pressed():
			get_node(down_arrow).play_press()
		else:
			get_node(down_arrow).play_default()
		pass

func recieve_enemy_up_input(event : InputEvent):
	if !player_track:
		if event.is_pressed():
			get_node(up_arrow).play_press()
		else:
			get_node(up_arrow).play_default()
		pass

func recieve_enemy_right_input(event : InputEvent):
	if !player_track:
		if event.is_pressed():
			get_node(right_arrow).play_press()
		else:
			get_node(right_arrow).play_default()
		pass



func recieve_enemy_hit(note : Note, hit_error):
	if !player_track:
		var enemy_input = InputEventAction.new()
		enemy_input.pressed = true
		match note.note_type:
			0:
				enemy_input.action = "note_left"
				get_tree().call_group("Enemy Input Recievers", "recieve_enemy_left_input", enemy_input)
				if !note.hold_note:
					get_node(left_timer).start(0.3)
					get_node(left_arrow).play_confirm()
				else:
					get_node(left_arrow).play_confirm_loop()
			1:
				enemy_input.action = "note_down"
				get_tree().call_group("Enemy Input Recievers", "recieve_enemy_down_input", enemy_input)
				if !note.hold_note:
					get_node(down_timer).start(0.3)
					get_node(down_arrow).play_confirm()
				else:
					get_node(down_arrow).play_confirm_loop()
			2:
				enemy_input.action = "note_up"
				get_tree().call_group("Enemy Input Recievers", "recieve_enemy_up_input", enemy_input)
				if !note.hold_note:
					get_node(up_timer).start(0.3)
					get_node(up_arrow).play_confirm()
				else:
					get_node(up_arrow).play_confirm_loop()
			3:
				enemy_input.action = "note_right"
				get_tree().call_group("Enemy Input Recievers", "recieve_enemy_right_input", enemy_input)
				if !note.hold_note:
					get_node(right_timer).start(0.3)
					get_node(right_arrow).play_confirm()
				else:
					get_node(right_arrow).play_confirm_loop()
			
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)


# Called when the node enters the scene tree for the first time.
func _ready():
	if "scroll_speed" in GameData.data.settings:
		scroll_speed = GameData.data.settings.scroll_speed
		if sign(GameData.data.settings.scroll_direction) != 0:
			scroll_speed *= sign(GameData.data.settings.scroll_direction)
	self.scroll_speed = scroll_speed
	pass # Replace with function body.

func recieve_song_time(n_time):
	song_time = n_time
	get_node(left_note_track).song_time = n_time
	get_node(down_note_track).song_time = n_time
	get_node(up_note_track).song_time = n_time
	get_node(right_note_track).song_time = n_time
	update_notes()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recieve_setting(setting, value):
	match setting:
		"scroll_speed":
			self.scroll_speed = value
		"scroll_direction":
			self.scroll_speed *= value
			pass
	pass


func _on_Left_Input_Timer_timeout():
	var enemy_input = InputEventAction.new()
	enemy_input.pressed = false
	enemy_input.action = "note_left"
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_left_input", enemy_input)
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)
	pass # Replace with function body.


func _on_Down_Input_Timer_timeout():
	var enemy_input = InputEventAction.new()
	enemy_input.pressed = false
	enemy_input.action = "note_down"
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_down_input", enemy_input)
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)
	pass # Replace with function body.


func _on_Up_Input_Timer_timeout():
	var enemy_input = InputEventAction.new()
	enemy_input.pressed = false
	enemy_input.action = "note_up"
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_up_input", enemy_input)
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)
	pass # Replace with function body.


func _on_Right_Input_Timer_timeout():
	var enemy_input = InputEventAction.new()
	enemy_input.pressed = false
	enemy_input.action = "note_right"
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_right_input", enemy_input)
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)
	pass # Replace with function body.


func _on_Left_Notes_holding_note(holding):
#	print("yeah left hold noteasd ", holding)
#	print("player track? ", player_track)
	if !player_track and !holding:
		var enemy_input = InputEventAction.new()
		enemy_input.pressed = false
		enemy_input.action = "note_left"
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_left_input", enemy_input)
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)
	pass # Replace with function body.


func _on_Down_Notes_holding_note(holding):
	if !player_track and !holding:
		var enemy_input = InputEventAction.new()
		enemy_input.pressed = false
		enemy_input.action = "note_down"
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_down_input", enemy_input)
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)
	pass # Replace with function body.

func _on_Up_Notes_holding_note(holding):
	if !player_track and !holding:
		var enemy_input = InputEventAction.new()
		enemy_input.pressed = false
		enemy_input.action = "note_up"
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_up_input", enemy_input)
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)

func _on_Right_Notes_holding_note(holding):
	if !player_track and !holding:
		var enemy_input = InputEventAction.new()
		enemy_input.pressed = false
		enemy_input.action = "note_right"
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_right_input", enemy_input)
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input", enemy_input)
