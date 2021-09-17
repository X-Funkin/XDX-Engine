extends Node2D
class_name WaveformChunk

export(int) var starting_sample = 0
export(int) var ending_sample = 44100
export(AudioStreamSample) var audio_stream : AudioStreamSample
export(bool) var multi_threading = false
var draw = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal draw_start
signal draw_complete

func multithread_draw(yeah):
#	_draw()
	draw = true
	update()
	return 1

func _draw(): #Function calling is like 3 times slower than direct computation, that's why there aren't any get_sample() functions here
	emit_signal("draw_start")
	if multi_threading:
		if !draw:
			return 0
	var bytes_per_sample = 1
	match int(audio_stream.stereo)+audio_stream.format:
		0:
			bytes_per_sample = 1
		1:
			bytes_per_sample = 2
		2:
			bytes_per_sample = 4
#			bytes2var()
	var sample_data = StreamPeerBuffer.new()
	sample_data.data_array = audio_stream.data.subarray(starting_sample*bytes_per_sample,min(ending_sample*bytes_per_sample,audio_stream.data.size()))
	var sample_rate = audio_stream.mix_rate
#	var sample_data = audio_stream.data.subarray(starting_sample*bytes_per_sample,ending_sample*bytes_per_sample)
	var point : Vector2 = Vector2(0,0)
	if audio_stream.stereo:
		if audio_stream.format:
			var x = sample_data.get_16()
			var y = sample_data.get_16()
			point.x = x/32767.0
			for sample in range(ending_sample-starting_sample):
				x = sample_data.get_16()
				y = sample_data.get_16()
				var new_point = Vector2(x/32767.0,float(sample)/sample_rate)
				draw_line(1000.0*point,1000.0*new_point,Color(1,1,1))
				point = new_point
		else:
			var x = sample_data.get_8()
			var y = sample_data.get_8()
			point.x = x/127.0
			for sample in range(ending_sample-starting_sample):
				x = sample_data.get_8()
				y = sample_data.get_8()
				var new_point = Vector2(x/127.0,float(sample)/sample_rate)
				draw_line(1000.0*point,1000.0*new_point,Color(1,1,1))
				point = new_point
	else:
		if audio_stream.format:
			var x = sample_data.get_16()
			point.x = x/32767.0
			for sample in range(ending_sample-starting_sample):
				x = sample_data.get_16()
				var new_point = Vector2(x/32767.0,float(sample)/sample_rate)
				draw_line(1000.0*point,1000.0*new_point,Color(1,1,1))
				point = new_point
		else:
			var x = sample_data.get_8()
			point.x = x/127.0
			for sample in range(ending_sample-starting_sample):
				x = sample_data.get_8()
				var new_point = Vector2(x/127.0, float(sample)/sample_rate)
				draw_line(1000.0*point,1000.0*new_point,Color(1,1,1))
				point = new_point
	for sample in range(ending_sample-starting_sample):
		pass
	emit_signal("draw_complete")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
