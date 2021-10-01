#tool
extends Node2D
class_name ChartEditor


export(float) var song_time
export(bool) var song_playing = false

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
	var start_time = from_time/1000.0
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


func seek_song_time(time):
	seek_audio(time)

func recieve_enemy_audio_stream(stream):
	$Instumentals.stream = stream
	get_tree().call_group("Song Time Recievers", "recieve_song_length", $Instumentals.stream.get_length()*1000.0)

func recieve_song_playing(playing):
	song_playing = playing
	if song_playing:
		play_audio(song_time)
	else:
		pause_audio(true)

func recieve_song_time(time):
	song_time = time

var thing = true
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE and event.pressed:
#			play_audio(0.0)
			get_tree().call_group("Song Time Recievers", "recieve_song_playing", !song_playing)
		if event.scancode == KEY_TAB and event.pressed:
			$"Control/Control/Export Editor".visible = thing
			$"Control/Control/Note Editor".modulate = Color(1,1,1,1)*float(!thing)
			thing = !thing
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

