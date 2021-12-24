extends Control


export(float) var visibility_begin = 0
export(float) var visibility_end = 1000.0
export(float) var visible_length = 1000.0
export(float) var size = 1000.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func redraw_waveforms():
	return 0
	$"Enemy Vocals/Position2D/Waveform Visualizer".start_time = visibility_begin
	$"Enemy Vocals/Position2D/Waveform Visualizer".end_time = visibility_end
	$"Enemy Vocals/Position2D/Waveform Visualizer".draw_waveform()

func recieve_song_time(song_time):
#	$Instrumentals.rect_position.y = song_time
	visibility_begin = song_time
	visibility_end = visibility_begin+visible_length
#	$.position.y = -song_time
	$"Enemy Vocals/Position2D/Waveform Visualizer".position.y = -song_time
	$"Instrumentals/Position2D/Waveform Visualizer".position.y = -song_time
	$"Player Vocals/Position2D/Waveform Visualizer".position.y = -song_time
	
	redraw_waveforms()

func recieve_zoom(zoom):
	visible_length = size/zoom
#	rect_scale.y = zoom
	$Instrumentals/Position2D.scale.y = zoom
	$"Enemy Vocals/Position2D".scale.y = zoom
	$"Player Vocals/Position2D".scale.y = zoom
	redraw_waveforms()

func recieve_enemy_audio_stream(stream):
	$"Enemy Vocals/Position2D/Waveform Visualizer".clear_waveforms()
#	return 0
	$"Enemy Vocals/Position2D/Waveform Visualizer".audio_stream = stream
	$"Enemy Vocals/Position2D/Waveform Visualizer".draw_waveform()

func recieve_instrumentals_audio_stream(stream):
	$"Instrumentals/Position2D/Waveform Visualizer".clear_waveforms()
#	return 0
	$"Instrumentals/Position2D/Waveform Visualizer".audio_stream = stream
	$"Instrumentals/Position2D/Waveform Visualizer".draw_waveform()

func recieve_player_audio_stream(stream):
	$"Player Vocals/Position2D/Waveform Visualizer".clear_waveforms()
#	return 0
	$"Player Vocals/Position2D/Waveform Visualizer".audio_stream = stream
	$"Player Vocals/Position2D/Waveform Visualizer".draw_waveform()
	pass

func recieve_enemy_waveform_hide(hidden):
	if hidden:
		$"Enemy Vocals".modulate = Color.transparent
	else:
		$"Enemy Vocals".modulate = Color.white

func recieve_instrumentals_waveform_hide(hidden):
	print("inst hide ", hidden)
	if hidden:
		$Instrumentals.modulate = Color.transparent
	else:
		$Instrumentals.modulate = Color.white

func recieve_player_waveform_hide(hidden):
	if hidden:
		$"Player Vocals".modulate = Color.transparent
	else:
		$"Player Vocals".modulate = Color.white

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
