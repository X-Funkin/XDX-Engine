#tool
extends Node2D
class_name WaveformVisualizer

export(String, FILE, "*.wav") var wav_file
export(AudioStreamSample) var audio_stream
export(float) var start_time = 0.0
export(float) var end_time = 1000.0
export(int) var draw_samples = 1000
export(int) var draw_sub_samples = 4
export(int) var chunk_size = 44100
export(bool) var can_redraw = true
var t0 = 0
var t1 = 0
var drawing = false
var frame_alt = false
var current_alt = false

var waveform_chunk = preload("res://assets/scenes/Waveform Chunk.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal debug_array(array)
func _process(delta):
#	print(drawing, " ", delta)
	if drawing and frame_alt != current_alt:
		t1 = OS.get_ticks_usec()
		print("DONE DRAWING")
		print(t1)
		print("Took ", t1-t0, " Microseconds")
		emit_signal("debug_array", [chunk_size,t1-t0])
		print(get_child_count(), " Child Nodes here")
		drawing = false
		t0 = 0
		t1 = 0
	frame_alt = not frame_alt
#	pass

func draw_waveform(multi_threading = false):
#	update()
#	return 0
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
			current_sample = new_sample
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
	return 1
	pass

func clear_waveforms():
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
