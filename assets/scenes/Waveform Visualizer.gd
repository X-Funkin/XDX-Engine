#tool
extends Node2D
class_name WaveformVisualizer

export(String, FILE, "*.wav") var wav_file
export(String, FILE, "*.wav") var wav_file_2
export(int, "File 1", "File 2") var load_wav_file

export(AudioStreamSample) var audio_stream
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("\n\n\nyeha here we go\n")
	var ydhda = ChartEditor.new()
	
	var target_wav
	match load_wav_file:
		0:
			target_wav = wav_file
		1:
			target_wav = wav_file_2
	var new_audio_stream = ydhda.load_wav_file(target_wav)
	if audio_stream != null:
		print(audio_stream, " ", audio_stream.data.size())
	if new_audio_stream is AudioStreamSample:
		print("yuppers it is autio stream")
		if new_audio_stream == null:
			print("yeah but it do be null tho")
	else:
		print("brooo it aint no isn't wooooorkkkkk")
	print(new_audio_stream, " ", new_audio_stream.data.size())
	print(typeof(audio_stream), " ", typeof(new_audio_stream), " ", typeof(null), " ", TYPE_OBJECT)
	audio_stream = new_audio_stream
	print(audio_stream)
	var audio_player = AudioStreamPlayer.new()
	var test_new_strem = AudioStreamSample.new()
#	print(audio_player.stream.get_length())
	add_child(audio_player)
	audio_player.stream = audio_stream
	print(audio_stream.get_length())
	print(audio_player.stream.get_length())
	audio_player.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
