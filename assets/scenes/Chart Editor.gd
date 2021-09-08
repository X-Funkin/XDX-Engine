tool
extends Node2D
class_name ChartEditor


export(String, FILE, GLOBAL) var test_file

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_mono_samples(byte_array : PoolByteArray, bit_depth = 16):
	var data_buffer = StreamPeerBuffer.new()
	data_buffer.data_array = byte_array
	var samples : PoolRealArray
	while !data_buffer.data_array.empty():
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
	for i in range(10000):
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
	print(wav_data)
	return wav_data
	pass

func load_wav_file(path):
	var thing = load(path)
	print(thing)
	print(typeof(thing))
	if thing == null:
		print("ooops")
		var file = File.new()
		file.open(path, File.READ)
		var parsed_wav = parse_wav_data(file)
		print(len(parsed_wav.data))
		thing = generate_audio_stream_sample(parsed_wav)
#		var thingy = file.get_buffer()
	return thing
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	print("\n\nyeahuyeayayeha\n")
	var thingy = load_wav_file(test_file)
	$AudioStreamPlayer.stream = thingy
	$AudioStreamPlayer.play()
	print("okay getting samples")
	var samples = get_stream_samples(thingy)
	print("got samples ", samples)
	pass # Replace with function body.

func _draw():
	return 0
	print("drawing")
	var thingy = load_wav_file(test_file)
	print("loaded file ", thingy)
	var samples = get_stream_samples(thingy)
#	var bit_depth = 16
#	var data_buffer = StreamPeerBuffer.new()
#	data_buffer.data_array = thingy.data
#	var samples : PoolVector2Array
#	while !data_buffer.data_array.empty():
#		if bit_depth == 16:
#			var x = data_buffer.get_16()/32767.0
#			var y = data_buffer.get_16()/32767.0
#			samples.append(Vector2(x,y))
#		elif bit_depth == 8:
#			var x = data_buffer.get_8()/127.0
#			var y = data_buffer.get_8()/127.0
#			samples.append(Vector2(x,y))
#		else:
#			return null
#		pass
	print("got samples ", samples)
	var sample_rate = thingy.mix_rate
	print("loopoing now lol ")
	if samples != null:
		var current_point = samples[0]
		var current_sample = 0
		print("yup all good rn time to for loop")
		for sample in samples:
			var new_point = sample
			draw_line(Vector2(current_point.x,current_sample/sample_rate),Vector2(new_point.x,current_sample/sample_rate), Color(1,1,1))
			current_point = new_point
			current_sample += 1
			if current_sample %1000 == 0:
				print(current_sample, " drawn so far!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
