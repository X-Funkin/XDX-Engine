#tool
extends Node2D
class_name ChartEditor


export(float) var song_time
export(bool) var song_playing = false
export(String) var chart_name
export(String) var chart_file
export(String) var save_file
export(float) var playback_speed = 1.0 setget set_playback_speed
export(float) var playback_offset = 0.0
export(Array, int) var version = [1,2,0]
var chart_data = {}

var audio_data : PoolVector2Array
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_mono_samples(byte_array : PoolByteArray, bit_depth = 16):
	print("get_mono_samples")
	var data_buffer = StreamPeerBuffer.new()
	data_buffer.data_array = byte_array
	var samples : PoolRealArray
	var loop_range = byte_array.size()/(2*bit_depth/8)
	for i in range(loop_range):
#		print("LOOPING")
#		if i%1000 == 0:
#			print("yeah yeha ", i, " or ", 100.0*float(i)/loop_range)
		if data_buffer.data_array.empty():
			print("BUFFER'S EMPTY ", i)
			break
		if bit_depth == 16:
			var sample = data_buffer.get_16()/32767.0
			samples.append(sample)
		elif bit_depth == 8:
			var sample = data_buffer.get_8()/127.0
			samples.append(sample)
		else:
			return null
	return samples

func get_stereo_samples(byte_array : PoolByteArray, bit_depth = 16):
	print("get_stereo_samples")
	var data_buffer = StreamPeerBuffer.new()
	data_buffer.data_array = byte_array
	var samples : PoolVector2Array
	print(data_buffer.data_array.size())
	var loop_range = byte_array.size()/(2*bit_depth/8)
	for i in range(loop_range):
#		print("LOOPING")
#		if i%1000 == 0:
#			print("yeah yeha ", i, " or ", 100.0*float(i)/loop_range)
		if data_buffer.data_array.empty():
			print("BUFFER'S EMPTY ", i)
			break
#		print(data_buffer.data_array.size())
#		print(data_buffer.get_16())
		if bit_depth == 16:
			
			var x = data_buffer.get_16()/32767.0
			var y = data_buffer.get_16()/32767.0
			samples.append(Vector2(x,y))
		elif bit_depth == 8:
			var x = data_buffer.get_8()/127.0
			var y = data_buffer.get_8()/127.0
			samples.append(Vector2(x,y))
		else:
			return null
		pass
	return samples
	pass

func get_stream_samples(stream : AudioStreamSample):
	var samples = null
	if stream.stereo:
		samples = get_stereo_samples(stream.data, stream.format*8+8)
	else:
		samples = get_mono_samples(stream.data, stream.format*8+8)
	return samples
	pass

func generate_audio_stream_sample(parsed_wav_data):
	var stream = AudioStreamSample.new()
	if parsed_wav_data.bit_depth == 8:
		stream.format = AudioStreamSample.FORMAT_8_BITS
	elif parsed_wav_data.bit_depth == 16:
		stream.format = AudioStreamSample.FORMAT_16_BITS
	else:
		print("ERROROROR NOT 8 OR 16 BITS BRUH")
		return null
	stream.mix_rate = parsed_wav_data.sample_rate
	stream.stereo = (parsed_wav_data.channels == 2)
	stream.data = parsed_wav_data.data
	return stream

func parse_wav_data(file : File):
	var wav_data = {}
	wav_data["RIFF"] = file.get_buffer(4).get_string_from_utf8()
#	print(file.get_buffer(4).get_string_from_utf8())#.hex_encode()) #marks file as riff
#	print(file.get_buffer(4).hex_encode())
#	print(file.get_32()) #File Size
	wav_data["file_size"] = file.get_32()
#	print(file.get_buffer(4).get_string_from_utf8())#.hex_encode()) #WAVE Header Type
	wav_data["header"] = file.get_buffer(4).get_string_from_utf8()
#	print
#	print(file.get_buffer(4).get_string_from_utf8())#.hex_encode()) #Format Chunk Marker
#	print(file.get_buffer(4).hex_encode())
	wav_data["format_chunk_marker"] = file.get_buffer(4).get_string_from_utf8()
#	print(file.get_32()) #Length of fomat data as listed above
	wav_data["length_of_format_data"] = file.get_32()
#	print(file.get_buffer(2).hex_encode())
#	print(file.get_16()) #type of format (1 is pcm)
	wav_data["format_type"] = file.get_16()
#	print(file.get_buffer(2).hex_encode())
#	print(file.get_16()) # Number of Channels
	wav_data["channels"] = file.get_16()
#	print(file.get_buffer(4).hex_encode())
#	print(file.get_32()) # Sample Rate
	wav_data["sample_rate"] = file.get_32()
	print(file.get_32()) # (Sample Rate * BitsPerSample * Channels) / 8
	print(file.get_16()) # (BitsPerSample*Channels)/8 | 1=8M,2=8S/16M,4=16S
	
#	print(file.get_16()) # Bits Per Sample
	wav_data["bit_depth"] = file.get_16()
#	print(file.get_buffer(4).get_string_from_utf8()) #Data Chunk Header, marks the start of data lol
	wav_data["data_chunk_header"] = file.get_buffer(4).get_string_from_utf8()
	wav_data["data_size"] = file.get_32()
#	var byte_array = PoolByteArray([])
#	while !file.eof_reached():
#		byte_array.append_array(file.get_buffer(1))
	wav_data["data"] = file.get_buffer(wav_data["file_size"])
#	print(wav_data)
	return wav_data
	pass

func load_wav_file(path):
	print("\nloading ", path)
#	print(path[-4]+path[-3]+path[-2]+path[-1])
	var thing = load(path)
#	if not thing is AudioStreamSample:
#		thing = null
	print(thing)
	print(typeof(thing))
	if thing == null:
#		print("ooops")
		var file = File.new()
		var err = file.open(path, File.READ)
		if err != OK:
			print("There was an error opening the file ", path)
			return null
		var parsed_wav = parse_wav_data(file)
#		print(parsed_wav)
#		print(len(parsed_wav.data))
		thing = generate_audio_stream_sample(parsed_wav)
		return thing
#		var thingy = file.get_buffer()
	return thing
	pass


func play_audio(from_time):
	var start_time = max(from_time/1000.0,0)
	$"Enemy Vocals".play(start_time)
	$Instumentals.play(start_time)
	$"Player Vocals".play(start_time)

func pause_audio(pause_state):
	$"Enemy Vocals".playing = !pause_state
	$Instumentals.playing = !pause_state
	$"Player Vocals".playing = !pause_state
#	$"Enemy Vocals".stream_paused = pause_state
#	$Instumentals.stream_paused = pause_state
#	$"Player Vocals".stream_paused = pause_state


func seek_audio(seek_time):
	var time = seek_time/1000.0
	$"Enemy Vocals".seek(time)
	$Instumentals.seek(time)
	$"Player Vocals".seek(time)

func scrub_enemy_audio(time):
	$"Enemy Audio Scrubbing Timer".start(0.2)
	$"Enemy Vocals".play(max(time/1000.0,0.0))
	pass

func scrub_player_audio(time):
	$"Player Audio Scrubbing Timer".start(0.2)
	$"Player Vocals".play(max(time/1000.0,0.0))

func seek_song_time(time):
	seek_audio(time)

func set_playback_speed(n_speed):
	playback_speed = n_speed
	if not is_inside_tree(): yield(self,"ready")
	$"Enemy Vocals".pitch_scale = playback_speed
	$"Instumentals".pitch_scale = playback_speed
	$"Player Vocals".pitch_scale = playback_speed
	pass

func save():
	fill_chart_data()
	if !save_file:
		$"Control/Popups/Save File Dialog".popup()
		return 0
		pass
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_string(JSON.print(chart_data))
	file.close()
	pass

func load_chart(path):
	var file = File.new()
	file.open(path, File.READ)
	var text = file.get_as_text()
	var json_parse = JSON.parse(text)
	if json_parse.error == OK:
		chart_data = json_parse.result
		send_chart_data()
	pass


func fill_chart_data():
	get_tree().call_group("Chart Data Recievers", "send_chart_data", chart_data)

func send_chart_data():
	get_tree().call_group("Chart Data Recievers", "recieve_chart_data", chart_data)
	recieve_chart_data(chart_data)

func fill_the_chart_data_yeah():
	chart_data["enemy_volume"] = db2linear($"Enemy Vocals".volume_db)
	chart_data["instrumentals_volume"] = db2linear($Instumentals.volume_db)
	chart_data["player_volume"] = db2linear($"Player Vocals".volume_db)

#func fill_audio_data():
#	if $"Enemy Vocals".stream:
#		chart_data["enemy_audio"] = $"Enemy Vocals".stream.get_
#	pass

func recieve_enemy_audio_path(path):
	chart_data["enemy_audio"] = path
#	$"Enemy Vocals".stream = stream
#	get_tree().call_group("Song Time Recievers", "recieve_song_length", $Instumentals.stream.get_length()*1000.0)

func recieve_instrumentals_audio_path(path):
	chart_data["instrumentals_audio"] = path
#	$Instumentals.stream = stream
#	get_tree().call_group("Song Time Recievers", "recieve_song_length", $Instumentals.stream.get_length()*1000.0)

func recieve_player_audio_path(path):
	chart_data["player_audio"] = path
#	$"Player Vocals".stream = stream

func recieve_enemy_audio_stream(stream):
	$"Enemy Vocals".stream = stream
#	get_tree().call_group("Song Time Recievers", "recieve_song_length", $Instumentals.stream.get_length()*1000.0)

func recieve_instrumentals_audio_stream(stream):
	$Instumentals.stream = stream
	get_tree().call_group("Song Time Recievers", "recieve_song_length", $Instumentals.stream.get_length()*1000.0)

func recieve_player_audio_stream(stream):
	$"Player Vocals".stream = stream

func recieve_enemy_volume(volume):
	$"Enemy Vocals".volume_db = linear2db(volume/100.0)

func recieve_instrumentals_volume(volume):
	$Instumentals.volume_db = linear2db(volume/100.0)

func recieve_player_volume(volume):
	$"Player Vocals".volume_db = linear2db(volume/100.0)

func recieve_song_playing(playing):
	song_playing = playing
	if song_playing:
		play_audio(song_time)
	else:
		pause_audio(true)

func recieve_song_time(time):
#	if song_time > time:
#		print("JUMP BACK ", song_time-time, " BRUHHH ", song_time, " ", time)
	song_time = time

func recieve_chart_file(path):
	chart_file = path
	match path.split(".")[-1]:
		"chart":
			load_chart(path)
#	var file = File.new()
#	file.open(path, File.READ)
#	var thingy = JSON.parse(file.get_as_text()).result
#	var strthing = JSON.print(thingy, "\t")
#	file.close()
#	file.open("res://filething.json", File.WRITE)
#	file.store_string(strthing)

func recieve_chart_data(chart_data):
	if "enemy_volume" in chart_data:
		get_tree().call_group("Audio Stream Recievers", "recieve_enemy_volume", chart_data["enemy_volume"])
	if "instrumentals_volume" in chart_data:
		get_tree().call_group("Audio Stream Recievers", "recieve_instrumentals_volume", chart_data["instrumentals_volume"])
	if "player_volume" in chart_data:
		get_tree().call_group("Audio Stream Recievers", "recieve_player_volume", chart_data["player_volume"])
	
	pass


#func send_chart_data(n_chart_data):
#	pass

var thing = true
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE and event.pressed:
#			play_audio(0.0)
			get_tree().call_group("Song Time Recievers", "recieve_song_playing", !song_playing)
		if event.scancode == KEY_TAB and event.pressed:
			$"Control/Control/Export Editor".visible = thing
#			$"Control/Control/Note Editor".modulate = Color(1,1,1,1)*float(!thing)
			$"Control/Control/Note Editor".visible = !thing
			thing = !thing
	if event.is_action_pressed("save"):
		save()
		pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _input(event):
#	if event.is_actio


func _on_Enemy_Audio_Scrubbing_Timer_timeout():
	print("ENEMY SCRUB TIMEOUT")
#	seek_audio(song_time)
	$"Enemy Vocals".stop()
#	$"Enemy Vocals".stream_paused = true
#	$"Enemy Vocals".playing = false
#	pause_audio(true)
#	$"Enemy Vocals".stream_paused = false
	pass # Replace with function body.


func _on_Player_Audio_Scrubbing_Timer_timeout():
	$"Player Vocals".stop()
	pass # Replace with function body.


func _on_Save_File_Dialog_file_selected(path):
	save_file = path
	save()
	
	pass # Replace with function body.
