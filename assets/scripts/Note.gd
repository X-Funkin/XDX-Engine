extends Node2D
class_name Note

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var hit_time
export(int, "Left", "Down", "Up", "Right") var note_type
export(bool) var hold_note
export(float) var hold_time setget set_hold_time
export(int) var note_index = 0
export(bool) var player_note
export(Dictionary) var custom_data
export(String) var scorable_group
export(bool) var scorable
export(bool) var active = true

func set_hold_time(n_time):
	pass # To be overwritten by the HoldNote class

func get_data():
#	get_index()
	var data_array = [hit_time, note_type, hold_time]
	if !custom_data.empty():
		data_array.append(custom_data)
	return data_array

class NoteSorter:
	static func sort_hit_time(a,b):
		return a.hit_time < b.hit_time
	static func search_hit_time(a,b):
		return a.hit_time < b

class NoteDataSorter:
	static func sort_hit_time(a,b):
		return a[0] < b[0]
	static func search_hit_time(a,b):
		return a[0] < b
# Called when the node enters the scene tree for the first time.

func check_scorability():
	var song_time = get_parent().song_time
	var timing_window = get_parent().timing_window
	if !scorable:
#		print("nah not scorable")
		if abs(hit_time-song_time) < timing_window:
#			print("alrighty will do")
			scorable = true
			add_to_group(scorable_group)
	else:
		if abs(hit_time-song_time) > timing_window:
			scorable = false
			remove_from_group(scorable_group)
		if song_time > hit_time+timing_window:
			get_tree().call_group("Player Miss Recievers", "recieve_player_miss", note_type)
			despawn()
	pass

func check_auto_play():
	var song_time = get_parent().song_time
	if song_time > hit_time:
		get_tree().call_group("Enemy Hit Recievers", "recieve_enemy_hit", self, 0.0)
		despawn()


func check_active():
	var song_time = get_parent().song_time
	var timing_window = get_parent().timing_window
	if !active:
		if hit_time < song_time-timing_window:
			spawn()
	else:
		if hit_time > song_time+timing_window:
			despawn()
			

func despawn():
	active = false
	visible = false
	scorable = false
	if is_in_group(scorable_group):
		remove_from_group(scorable_group)
	set_process(false)

func spawn():
	active = true
	visible = true

func _ready():
	
#	check_active()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	check_active()
	if active:
		if player_note:
#			print("adjfd")
			check_scorability()
		else:
			check_auto_play()
	if get_parent().song_time < hit_time-1000.0:
			set_process(false)
#	pass
