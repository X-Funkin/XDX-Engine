extends AudioStreamPlayer


export(String) var song_time_group = "Song Time Recievers"
export(float) var offset_ms = 0.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if "offset_ms" in GameData.data.settings:
		offset_ms = GameData.data.settings.offset_ms
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

var t = 0.0
var prev_time = 0.0
var old_song_time = 0.0
func get_song_time(delta):
	var current_time = get_playback_position()+AudioServer.get_time_since_last_mix()-AudioServer.get_output_latency()
	t += delta
	if t > 1.0:
		t = 0.0
		print(current_time)
	
	if current_time < prev_time:
		if delta != 0:
			if abs((current_time-prev_time)/delta) > 10.0:
				prev_time = 0.0
				emit_signal("finished")
		current_time = prev_time + delta*pitch_scale
	get_tree().call_group(song_time_group, "recieve_song_time", current_time*1000.0+offset_ms)
	var new_song_time = current_time*1000.0+offset_ms
	if old_song_time > new_song_time:
		print("YEAH SOMETHING WENT WRONG IN THE INTRUEMANTALS FUNCITON ")
		print(old_song_time)
		print(new_song_time)
		print(old_song_time-new_song_time)
	old_song_time = new_song_time
	prev_time = current_time

func seek_song_time(seek_time):
	prev_time = 0.0

var song_playing = false
func _process(delta):
	if playing:
		get_song_time(delta)
	if song_playing != playing:
		song_playing = playing
#		get_tree().call_group("yeah","yeah")
#	pass
