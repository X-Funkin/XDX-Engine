#tool
extends Node2D
class_name WaveformVisualizer

export(String, FILE, "*.wav") var wav_file
export(AudioStreamSample) var audio_stream
export(Image) var wave_image = Image.new()
export(ImageTexture) var wave_texture = ImageTexture.new()
export(NodePath) var wave_mesh_node = @"Wave Mesh"
export(float) var start_time = 0.0 setget set_start_time
export(float) var end_time = 1000.0 setget set_end_time
export(int) var draw_samples = 12000
export(int) var draw_sub_samples = 4
export(int) var chunk_size = 44100
export(bool) var can_redraw = true
export(bool) var progressive_draw = true
export(String) var draw_progress_group
export(float,0.0,1.0) var debug_mix setget set_debug_mix
var progress : float = 0.0
#export(NodePath) var mesh_obj
var t0 = 0
var t1 = 0
var drawing = false
var frame_alt = false
var current_alt = false

var waveform_chunk = preload("res://assets/scenes/Waveform Chunk.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_debug_mix(n_mix):
	debug_mix = n_mix
	if not is_inside_tree(): yield(self,"ready")

func set_start_time(n_time):
	start_time = n_time
	if not is_inside_tree(): yield(self,"ready")
	update_wave_mesh()



func set_end_time(n_time):
	end_time = n_time
	if not is_inside_tree(): yield(self,"ready")
	update_wave_mesh()

signal debug_array(array)
func _process(delta):
	if drawing:
		get_tree().call_group(draw_progress_group, "recieve_waveform_draw_progress", progress)
		
##	print(drawing, " ", delta)
#	if drawing and frame_alt != current_alt:
#		t1 = OS.get_ticks_usec()
#		print("DONE DRAWING")
#		print(t1)
#		print("Took ", t1-t0, " Microseconds")
#		emit_signal("debug_array", [chunk_size,t1-t0])
#		print(get_child_count(), " Child Nodes here")
#		drawing = false
#		t0 = 0
#		t1 = 0
#	frame_alt = not frame_alt
#	pass

func update_wave_mesh():
	var wave_mesh = get_node_or_null(wave_mesh_node)
	if wave_mesh:
#		print("IN WAVE MESH YAY IT EXIST")
		wave_mesh.position.y = start_time
		wave_mesh.scale.y = end_time-start_time
		wave_mesh.material.set_shader_param("start_time", start_time)
		wave_mesh.material.set_shader_param("end_time", end_time)
		wave_mesh.material.set_shader_param("debug_mix", debug_mix)

func fill_wave_image():
	
	print("FILLING WAVE IMAGE")
	if audio_stream != null:
		drawing = true
		var num = 1
		if (audio_stream.stereo and audio_stream.format == 0) or (!audio_stream.stereo and audio_stream.format == 1):
			num = 2
		if (audio_stream.stereo and audio_stream.format == 1):
			num = 4
		var final_sample = len(audio_stream.data)/num
		var width = 16384
		var height = final_sample/16384+1
#		var image_format = Image.FORMAT
		var image = Image.new()
		image.create(width,height,false,Image.FORMAT_RGBAF)
		wave_image = image
#		var yeah : ImageTexture
#		yeah.set_data()
#		wave_texture.set_data(wave_image)
		wave_texture.create_from_image(wave_image, ImageTexture.FLAG_REPEAT)
		var buffer = StreamPeerBuffer.new()
		buffer.data_array = audio_stream.data
		for sample in range(final_sample):
			var samp_x = sample%width
			var samp_y = sample/width
			var x = 0
			var y = 0
			match num:
				1:
					x = buffer.get_8()/127.0
#					wave_image.set_pixel(samp_x,samp_y, Color(x,0.0,0.0,1.0))
				2:
					if audio_stream.format == AudioStreamSample.FORMAT_16_BITS:
						x = buffer.get_16()/32767.0
						
						pass
					else:
						x = buffer.get_8()/127.0
						y = buffer.get_8()/127.0
				4:
					x = buffer.get_16()/32767.0
					y = buffer.get_16()/32767.0
			pass
			var col = Color(x,y,0.0,1.0)
			wave_image.lock()
			wave_image.set_pixel(samp_x,samp_y,col)
			wave_image.unlock()
			progress = sample/float(final_sample)
		wave_texture.set_data(wave_image)
		wave_texture.flags = ImageTexture.FLAG_REPEAT
		get_tree().call_group(draw_progress_group, "recieve_waveform_draw_finish")
		drawing = false
	pass

func generate_wave_mesh():
	print("GENERATEING WAVE MESH")
	var vertz = PoolVector3Array()
	var start = Vector3(0,0,0)
	var end = Vector3(0,1.0,0)
	var segments = draw_samples*draw_sub_samples
#	vertz.push_back(Vector3(0,0,0))
#	vertz.push_back(Vector3(0,1,0))
#	vertz.push_back(Vector3(0,1,0))
#	vertz.push_back(Vector3(0,2,0))
#	vertz.push_back(Vector3(0,2,0))
#	vertz.push_back(Vector3(0,3,0))
	vertz.resize(segments*2)
	var vec = start
	print("MADE VERT ARRAY ", vertz.size())
	for i in range(0,segments):
		vertz[2*i] = vec
		vec = lerp(start,end,i/float(segments))
		vertz[2*i+1] = vec
		pass
	print("FILLED VERTZ ARRAY ")
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertz
#	print(arrays[ArrayMesh.ARRAY_VERTEX])
	var arr_mesh := ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
#	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS,arrays)
	print("ADDED THING TO MESH INSTANCE")
	var wave_mesh = get_node_or_null(wave_mesh_node)
#	var wave_mesh = get_node(wave_mesh_node)
#	var wave_mesh = get_child(0)
	print(wave_mesh_node)
	print(wave_mesh)
	$"Wave Mesh".mesh = arr_mesh
#	get_parent().mesh_yeah = arr_mesh
	if wave_mesh:
		print("IN WAVE MESH YAY IT EXIST")
		wave_mesh.mesh = arr_mesh
		wave_mesh.material.set_shader_param("Wav_Tex", wave_texture)
		wave_mesh.material.set_shader_param("start_time", start_time)
		wave_mesh.material.set_shader_param("end_time", end_time)
#		wave_mesh.material.set_shader_param("sample_rate", 44100)
		if audio_stream:
			var sample_rate = audio_stream.mix_rate
			wave_mesh.material.set_shader_param("sample_rate", sample_rate)
	pass

func draw_waveform(multi_threading = false):
	print("DRAWING WAVEFORMS")
	get_tree().call_group(draw_progress_group, "recieve_waveform_draw_start")
	generate_wave_mesh()
	if multi_threading:
		var thread = Thread.new()
		thread.start(self,"fill_wave_image")
	else:
		fill_wave_image()
#	thread.wait_to_finish()
	pass

func draw_waveformzszszszzz(multi_threading = false):
#	update()
#	return 0
	get_tree().call_group(draw_progress_group, "recieve_waveform_draw_start")
	
	print("\n\n\nSTARTING WAVEFORM DRAW")
	print("CHUNK SIZE: ", chunk_size)
	t0 = OS.get_ticks_usec()
	t1 = OS.get_ticks_usec()
	current_alt = frame_alt
	print(t0)
#	yield(self,"pr")
	if audio_stream != null:
		var num = 1
		if (audio_stream.stereo and audio_stream.format == 0) or (!audio_stream.stereo and audio_stream.format == 1):
			num = 2
		if (audio_stream.stereo and audio_stream.format == 1):
			num = 4
		var final_sample = len(audio_stream.data)/num
		var current_sample = 0
		get_tree().call_group(draw_progress_group, "recieve_waveform_total_chunks", int(ceil(final_sample/chunk_size)))
		while current_sample < final_sample:
			var new_sample = min(current_sample + chunk_size, final_sample)
			var waveinst = waveform_chunk.instance()
			waveinst.starting_sample = current_sample
			waveinst.ending_sample = new_sample
			waveinst.audio_stream = audio_stream
			waveinst.position.y = 1000.0*float(current_sample)/float(audio_stream.mix_rate)
			if multi_threading:
				waveinst.multi_threading = true
			add_child(waveinst)
			get_tree().call_group(draw_progress_group, "recieve_waveform_current_chunk", int(ceil(current_sample/chunk_size)))
			current_sample = new_sample
			if progressive_draw:
				yield(get_tree(),"idle_frame")
	drawing = true
	
	if multi_threading:
		for node in get_children():
			yield(get_tree(), "idle_frame")
			var thread = Thread.new()
			thread.start(node, "multithread_draw")
#			thread.wait_to_finish()
	
#	t1 = OS.get_ticks_usec()
	print("WAVE DRAWING DONE")
#	print("Took ", t1-t0, " Microseconds")
	get_tree().call_group(draw_progress_group, "recieve_waveform_draw_finish")
	return 1
	pass

func clear_waveforms():
	return 0
	for node in get_children():
		node.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	var thingy = ChartEditor.new()
	audio_stream = thingy.load_wav_file(wav_file)
#	print("\n\n\nyeha here we go\n")
#	var ydhda = ChartEditor.new()
#
#	var target_wav
#	match load_wav_file:
#		0:
#			target_wav = wav_file
#		1:
#			target_wav = wav_file_2
#	var new_audio_stream = ydhda.load_wav_file(target_wav)
#	if audio_stream != null:
#		print(audio_stream, " ", audio_stream.data.size())
#	if new_audio_stream is AudioStreamSample:
#		print("yuppers it is autio stream")
#		if new_audio_stream == null:
#			print("yeah but it do be null tho")
#	else:
#		print("brooo it aint no isn't wooooorkkkkk")
#	print(new_audio_stream, " ", new_audio_stream.data.size())
#	print(typeof(audio_stream), " ", typeof(new_audio_stream), " ", typeof(null), " ", TYPE_OBJECT)
#	audio_stream = new_audio_stream
#	print(audio_stream)
#	var audio_player = AudioStreamPlayer.new()
#	var test_new_strem = AudioStreamSample.new()
##	print(audio_player.stream.get_length())
#	add_child(audio_player)
#	audio_player.stream = audio_stream
#	print(audio_stream.get_length())
#	print(audio_player.stream.get_length())
#	audio_player.play()
	pass # Replace with function body.

func _drawb():
	print("\nDRAWING...")
	draw_line(Vector2(-1000.0,max(0,start_time)),Vector2(1000.0,max(0,start_time)), Color(1,0,0))
	draw_line(Vector2(-1000.0,end_time),Vector2(1000.0,end_time), Color(0,1,0))
	
	if audio_stream != null:
		print("YUP STREAM")
		print("AUDIO STREAM FORAMT ", audio_stream.format)
		print("AUDIO STREAM STEREO ", audio_stream.stereo)
		print("AUDIO STREAM SAMPLE RATE ", audio_stream.mix_rate)
		var bytes_per_sample = 1
		match int(audio_stream.stereo)+audio_stream.format:
			0:
				bytes_per_sample = 1
			1:
				bytes_per_sample = 2
			2:
				bytes_per_sample = 4
	#			bytes2var()
		print("BYTES PER SAMPLE ", bytes_per_sample)
		var stream_length = 1000.0*(audio_stream.data.size()/bytes_per_sample)/float(audio_stream.mix_rate)
		print("SAMPLE COUNT ",audio_stream.data.size()/bytes_per_sample)
		print("STREAM LENGTH ", stream_length)
		var sample_data = StreamPeerBuffer.new()
		var starting_sample = int(start_time/1000.0*audio_stream.mix_rate)
		var ending_sample = int(end_time/1000.0*audio_stream.mix_rate)
		print("START TIME ", start_time)
		print("END TIME ", end_time)
		print("STARTING SAMPLE ", starting_sample)
		print("ENDING SAMPLE ", ending_sample)
		print("AUDIO STREAM DATA SIZE ", audio_stream.data.size())
		print("BEGIN BYTE ", max(0,starting_sample*bytes_per_sample))
		print("END BYTE ", min(ending_sample*bytes_per_sample,audio_stream.data.size()-1))
		sample_data.data_array = audio_stream.data.subarray(max(0,starting_sample*bytes_per_sample),min(ending_sample*bytes_per_sample,audio_stream.data.size()-1))
		var sub_sample_data = StreamPeerBuffer.new()
		sub_sample_data.data_array = sample_data.data_array
		var sample_count = sample_data.data_array.size()/bytes_per_sample
		var current_sample = 0
		var point : Vector2
		var audio_stream_format = audio_stream.format
		var audio_stream_stereo = audio_stream.stereo
		if audio_stream_format == 1:
			point = Vector2(1000.0*sub_sample_data.get_16()/32767.0,max(0,start_time))
			
#			sub_sample_data.get_16()
		else:
			point = Vector2(1000.0*sub_sample_data.get_8()/127.0,max(0,start_time))
			
#		point = Vector2(1000.0*sin(start_time), start_time)
		for draw_sample in range(draw_samples*draw_sub_samples):
			var draw_sample_time = range_lerp(draw_sample,0,draw_samples*draw_sub_samples,max(0,start_time),min(end_time,stream_length))
			
			var completionthingy = range_lerp(draw_sample,0,draw_samples*draw_sub_samples,0.0,1.0)
			
#			if draw_sample*draw_sub_samples != 0:
#				completionthingy = draw_sample/float(draw_sample*draw_sub_samples)
			
			var new_sample = int(sample_count*float(draw_sample)/float(draw_samples*draw_sub_samples))
			if new_sample == current_sample:
				continue
			if new_sample > sample_count+1:
				break
			if new_sample-current_sample > 1:
#				var yeah = sub_sample_data.get_data((new_sample-current_sample)*bytes_per_sample)
				var yeah = sub_sample_data.get_partial_data((new_sample-current_sample-1)*bytes_per_sample)
				pass
#			sub_sample_data.data_array = sample_data.data_array.subarray(new_sample*bytes_per_sample,sample_count*bytes_per_sample-1)
			var new_point : Vector2
			if audio_stream_format == 1:
				new_point = Vector2(1000.0*sub_sample_data.get_16()/32767.0,draw_sample_time)
				if audio_stream_stereo:
					var yeah = sub_sample_data.get_16()
			else:
				new_point = Vector2(1000.0*sub_sample_data.get_8()/127.0,draw_sample_time)
				if audio_stream_stereo:
					var yeah = sub_sample_data.get_8()
			
#			new_point = Vector2(1000.0*sin(draw_sample_time),draw_sample_time)
			
			draw_line(point,new_point, Color(1,1,1))
			point = new_point
			current_sample = new_sample
	pass


func _drawc():
	draw_line(Vector2(-1000.0,start_time),Vector2(1000.0,start_time), Color(1,0,0))
	draw_line(Vector2(-1000.0,end_time),Vector2(1000.0,end_time), Color(0,1,0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
