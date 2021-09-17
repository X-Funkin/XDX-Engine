#tool
extends Node2D
class_name WaveformVisualizer

export(String, FILE, "*.wav") var wav_file
export(AudioStreamSample) var audio_stream
export(int) var chunk_size = 44100
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
