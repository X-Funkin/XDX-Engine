extends Control


export(float) var song_time = 0.0
export(float) var song_length = 1000.0
export(bool) var playing = false
export(Texture) var play_icon
export(Texture) var pause_icon
export(NodePath) var song_time_label
export(NodePath) var song_length_label
#export(int, "Playing", "Paused") var playing_state
#export()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recieve_song_length(length_ms):
	song_length = length_ms
	$"Player Head/HSlider".max_value = length_ms
	update_length_label()

func recieve_song_time(time):
	song_time = time
	update_time_label()
	pass

func update_time_label():
	var time = abs(song_time)/1000.0
	var second = fmod(time,60.0)
	var minute = int(floor(time/60.0))
	var label = get_node(song_time_label)
	var time_str = ""
	if song_time < 0.0:
		time_str = "-"
	if label:
		label.text = time_str+"%s:%2.3f"%[minute,second]
	pass

func update_length_label():
	var time = abs(song_length)/1000.0
	var second = fmod(time,60.0)
	var minute = int(floor(time/60.0))
	var label = get_node(song_length_label)
	var time_str = "/"
	if label:
		label.text = time_str+"%s:%2.3f"%[minute,second]

func parse_song_time_text(text : String):
	var times = text.split_floats(":")
	if times.size() == 1:
		var time = times[0]*1000.0
		get_tree().call_group("Song Time Recievers", "seek_song_time", time)
		get_tree().call_group("Song Time Recievers", "recieve_song_time", time)
	elif times.size() == 2:
		var minutes = times[0]
		var seconds = times[1]
		var time = (minutes*60+seconds)*1000.0
		get_tree().call_group("Song Time Recievers", "seek_song_time", time)
		get_tree().call_group("Song Time Recievers", "recieve_song_time", time)
	pass

func _on_HSlider_value_changed(value):
#	get_tree().call_group("Song Time Recievers", "seek_song_time", value)
	pass # Replace with function body.


func _on_HSlider_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("yeahgdhfiudjfjf")
			yield(get_tree(),"idle_frame")
			print("yeahah")
			song_time = $"Player Head/HSlider".value
			if playing:
				get_tree().call_group("Song Time Recievers", "seek_song_time", song_time)
				pass
			else:
				pass
				get_tree().call_group("Song Time Recievers", "recieve_song_time", song_time)
				get_tree().call_group("Song Time Recievers", "seek_song_time", song_time)
	pass # Replace with function body.


func _on_Button_pressed():
	playing = !playing
	get_tree().call_group("Song Time Recievers", "recieve_song_playing", playing)
	pass # Replace with function body.


func recieve_song_playing(playing):
	if playing:
		$"Player Button/Button/TextureRect".texture = pause_icon
	else:
		$"Player Button/Button/TextureRect".texture = play_icon


func _on_Song_Time_Box_text_entered(new_text):
	$"Label yeah/Song Time Box".release_focus()
	parse_song_time_text(new_text)
	pass # Replace with function body.
