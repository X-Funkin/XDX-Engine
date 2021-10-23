extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var instrumentals

# Called when the node enters the scene tree for the first time.
func _ready():
	print("yeah")
	$Timer.start()
	$"Note Track".load_chart()
	pass # Replace with function body.

var started = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !started:
		get_tree().call_group("Song Time Recievers", "recieve_song_time", -$Timer.time_left*1000.0)
#	pass


func _on_Timer_timeout():
	started = true
	$Instrumentals.play()
	$"Player Vocals".play()
	pass # Replace with function body.


func pause():
	var pause_screen = load("res://assets/scenes/Pause Menu.tscn").instance()
	var canvas = CanvasLayer.new()
	canvas.add_child(pause_screen)
	add_child(canvas)
	get_tree().paused = true

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
#		judge_hit(hit_error)
#		player_combo += 1
#		get_tree().call_group("Player Hit Recievers", "recieve_player_combo", player_combo)
#		get_node(label_thingy).text = "%5.4f ms"%hit_error
		if closest_note.hold_note:
			closest_note.holding = true
			closest_note.playing = true
			closest_note.score_note()
		else: closest_note.despawn()
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if !get_tree().paused:
			pause()
#	if event is InputEventKey:
#		if event.scancode == KEY_F12 and event.pressed and !event.is_echo():
#			screenshot()
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
	if !event.is_echo():
		if event.is_action("note_left"):
	#		print("note left")
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
	pass
#	get_node(player_vocals).volume_db = 0.0

func recieve_player_miss(note_type):
	pass
#	get_node(player_vocals).volume_db = -80.0
#	get_node(sounds_path).play_miss()

