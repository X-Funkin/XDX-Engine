extends GameWeek
class_name WeekSong

export(String) var song_name
export(String, FILE) var chart_file
export(NodePath) var player_track
export(NodePath) var enemy_track
export(NodePath) var player_vocals
export(NodePath) var instrumentals
export(NodePath) var enemy_vocals
export(NodePath) var label_thingy
var player_combo = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# Inputs
func _input(event):
	_player_input(event)
	get_tree().call_group("Input Recievers", "recieve_input")
	if event.is_action("note_left"):
		get_tree().call_group("Input Recievers", "recieve_left_input", event)
		return 0
	if event.is_action("note_down"):
		get_tree().call_group("Input Recievers", "recieve_down_input", event)
		return 0
	if event.is_action("note_up"):
		get_tree().call_group("Input Recievers", "recieve_up_input", event)
		return 0
	if event.is_action("note_right"):
		get_tree().call_group("Input Recievers", "recieve_right_input", event)
		return 0
	

func _player_input(event : InputEvent):
	get_tree().call_group("Player Input Recievers", "recieve_player_input", event)
	if event.is_action("note_left"):
		print("note left")
		get_tree().call_group("Player Input Recievers", "recieve_player_left_input", event)
		return 0
	if event.is_action("note_down"):
		get_tree().call_group("Player Input Recievers", "recieve_player_down_input", event)
		return 0
	if event.is_action("note_up"):
		get_tree().call_group("Player Input Recievers", "recieve_player_up_input", event)
		return 0
	if event.is_action("note_right"):
		get_tree().call_group("Player Input Recievers", "recieve_player_right_input", event)
		return 0
	
	

func _enemy_input(event : InputEvent):
	get_tree().call_group("Enemy Input Recievers", "recieve_enemy_input")
	if event.is_action("note_left"):
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_left_input", event)
		return 0
	if event.is_action("note_down"):
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_down_input", event)
		return 0
	if event.is_action("note_up"):
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_up_input", event)
		return 0
	if event.is_action("note_right"):
		get_tree().call_group("Enemy Input Recievers", "recieve_enemy_right_input", event)
		return 0
	

func recieve_player_left_input(event : InputEvent):
	if event.is_pressed():
#		print("supposidly coring")
		score_note("Scorable Left Notes")

func recieve_player_down_input(event : InputEvent):
	if event.is_pressed():
#		print("supposidly coring")
		score_note("Scorable Down Notes")

func recieve_player_up_input(event : InputEvent):
	if event.is_pressed():
#		print("supposidly coring")
		score_note("Scorable Up Notes")

func recieve_player_right_input(event : InputEvent):
	if event.is_pressed():
#		print("supposidly coring")
		score_note("Scorable Right Notes")

func recieve_player_hit(note : Note, hit_error):
	get_node(player_vocals).volume_db = 0.0

func recieve_player_miss(note_type):
	get_node(player_vocals).volume_db = -80.0
	$"Player Miss Sound".stop()
	$"Player Miss Sound".play()

func recieve_enemy_hit(note : Note, hit_error):
	get_node(enemy_vocals).volume_db = 0.0

func score_note(scoring_group):
#	print("funcing callced")
	var song_time = get_node(instrumentals).get_playback_position()+AudioServer.get_time_since_last_mix()-AudioServer.get_output_latency()
	song_time *= 1000.0
	song_time += get_node(instrumentals).offset_ms
	var scorable_notes = get_tree().get_nodes_in_group(scoring_group)
#	print("scorable notes ", scorable_notes)
	if scorable_notes != []:
		var closest_note : Note = scorable_notes[0]
		var hit_error = closest_note.hit_time-song_time
		for note in scorable_notes:
#			print("scorable note ", note)
			if abs(note.hit_time-song_time) < abs(hit_error):
				closest_note = note
				hit_error = closest_note.hit_time-song_time
		get_tree().call_group("Player Hit Recievers", "recieve_player_hit", closest_note, hit_error)
		judge_hit(hit_error)
		player_combo += 1
		get_tree().call_group("Player Hit Recievers", "recieve_player_combo", player_combo)
		get_node(label_thingy).text = "%5.4f ms"%hit_error
		
		closest_note.despawn()

func judge_hit(hit_error):
	var judgement = 1
	if abs(hit_error) <= 127.5:
		judgement = 1
	if abs(hit_error) <= 103.5:
		judgement = 2
	if abs(hit_error) <= 73.5:
		judgement = 3
	if abs(hit_error) <= 40.5:
		judgement = 4
	if abs(hit_error) <= 16.5:
		judgement = 5
	get_tree().call_group("Player Hit Recievers", "recieve_player_judgment", judgement)

func recieve_player_judgment(judgment):
	var col = Color("FF0000")
	match judgment:
		5:
			col = Color("00FFFF")
		4:
			col = Color("FFFFFF")
		3:
			col = Color("00FF00")
		2:
			col = Color("FF0000")
		
	get_node(label_thingy).modulate = col

func _ready():
	get_node(player_track).chart_file = chart_file
	get_node(enemy_track).chart_file = chart_file
	get_node(player_track).load_chart()
	get_node(enemy_track).load_chart()
	$Instrumentals.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
