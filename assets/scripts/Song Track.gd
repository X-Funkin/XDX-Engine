extends AudioStreamPlayer

export(String) var song_time_group = "Song Time Recievers"
export(float) var offset_ms = 0.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var t = 0.0
var prev_time = 0.0
func _process(delta):
	var current_time = get_playback_position()+AudioServer.get_time_since_last_mix()-AudioServer.get_output_latency()
	t += delta
	if t > 1.0:
		t = 0.0
		print(current_time)
	if current_time < prev_time:
		current_time = prev_time + delta*pitch_scale
	get_tree().call_group(song_time_group, "recieve_song_time", current_time*1000.0+offset_ms)
	prev_time = current_time
	pass
#	pass
