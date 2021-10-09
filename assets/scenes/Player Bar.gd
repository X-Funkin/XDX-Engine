extends Control


export(float) var song_time = 0.0
export(float) var song_length = 1000.0
export(bool) var playing = false
export(Texture) var play_icon
export(Texture) var pause_icon
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

func recieve_song_time(time):
	song_time = time
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
