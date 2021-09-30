extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export(float) var starting_time = 0
export(float) var ending_time = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			starting_time = ($"Waveform Visualizer".global_transform.affine_inverse() * get_global_mouse_position()).y
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			ending_time = ($"Waveform Visualizer".global_transform.affine_inverse() * get_global_mouse_position()).y
		
		if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT):
			$"Waveform Visualizer".start_time = starting_time
			$"Waveform Visualizer".end_time = ending_time
			$"Waveform Visualizer".draw_waveform()
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			starting_time = ($"Waveform Visualizer".global_transform.affine_inverse() * get_global_mouse_position()).y
			
			pass
		if event.button_index == BUTTON_RIGHT:
			ending_time = ($"Waveform Visualizer".global_transform.affine_inverse() * get_global_mouse_position()).y
		
		$"Waveform Visualizer".start_time = starting_time
		$"Waveform Visualizer".end_time = ending_time
		$"Waveform Visualizer".draw_waveform()
	if event.is_action_pressed("ui_accept"):
		$FileDialog.popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FileDialog_file_selected(path):
	var thingy = ChartEditor.new()
	var stream = thingy.load_wav_file(path)
	if stream != null:
		$"Waveform Visualizer".audio_stream = stream
		$"Waveform Visualizer".draw_waveform()
	pass # Replace with function body.
