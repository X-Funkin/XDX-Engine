extends AudioStreamPlayer

export(String) var song_time_group = "Song Time Recievers"
export(float) var offset_ms = 0.0
export(float) var bpm = 120.0
export(int) var count_down = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if "offset_ms" in GameData.data.settings:
		offset_ms = GameData.data.settings.offset_ms
	var countdown_node = get_node_or_null("Count Down Timer")
	if countdown_node:
		$"Count Down Timer".wait_time = 60.0/bpm
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var t = 0.0
var prev_time = 0.0
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
	if floor((current_time*1000.0+offset_ms)/(1000.0*60.0/bpm)) != floor((prev_time*1000.0+offset_ms)/(1000.0*60.0/bpm)):
		var beat_n = int(floor(current_time*1000.0+offset_ms)/(1000.0*60.0/bpm))
		print("BEAT ", beat_n)
		get_tree().call_group(song_time_group, "recieve_beat", beat_n)
	prev_time = current_time


func start():
	$"Count Down Timer".start()
var song_started = false


func get_timer_song_time():
	var base_time = $"Count Down Timer".wait_time
	var time_left = $"Count Down Timer".time_left
	var total_time_left = base_time * count_down + time_left
#	print("timer time lol %5.4f"%(total_time_left*1000.0+offset_ms))
	get_tree().call_group(song_time_group, "recieve_song_time", -total_time_left*1000.0+offset_ms)
	pass

var live = true
func _process(delta):
	if live:
		if song_started:
			get_song_time(delta)
		else:
			get_timer_song_time()
	pass
#	pass

func recieve_player_death():
#	set_process(false)
	live = false

func recieve_setting(setting, value):
	match setting:
		"offset_ms":
			offset_ms = value

func _on_Count_Down_Timer_timeout():
	get_tree().call_group("Count Down Recievers", "recieve_count_down", count_down)
	count_down -= 1
	if count_down >= 0:
		$"Count Down Timer".start(60.0/bpm)
		get_tree().call_group(song_time_group, "recieve_beat", -count_down)
	else:
		song_started = true
		play()
		$"Player Vocals".play()
		$"Enemy Vocals".play()
		
	pass # Replace with function body.
