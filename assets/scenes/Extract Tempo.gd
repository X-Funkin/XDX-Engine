extends WindowDialog

export(float) var start_time = 0.0
export(float) var end_time = 1.0
export(float) var note_time_diff = 1.0
export(float) var beats = 4.0
export(float) var tempo = 120
export(float) var snapping_offset = 0.0


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_tempo():
	if note_time_diff > 0.0:
		tempo = 1000.0*60.0/note_time_diff*beats/4
		$"Main UI/AspectRatioContainer/CenterContainer/VBoxContainer/Tempo Label".text = "Tempo: %4.2f"%tempo
		var beat_length = note_time_diff/beats
#		snapping_offset = stepify(start_time, beat_length)*1000.0
#		snapping_offset = fposmod(start_time, beat_length)
		snapping_offset = wrapf(start_time, -beat_length/2, beat_length/2)
		$"Main UI/AspectRatioContainer/CenterContainer/VBoxContainer/Snapping Offset Label".text = "Snapping Offset: %4.2f"%snapping_offset
		
	pass

func update_times():
	var notes = get_tree().get_nodes_in_group("Selected Notes")
	if notes != []:
		start_time = notes[0].hit_time
		end_time = notes[-1].hit_time
		note_time_diff = end_time - start_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recieve_extract_tempo():
	rect_global_position = get_global_mouse_position()-rect_size/2.0
	update_times()
	update_tempo()
	popup()

func _on_Cancel_Button_pressed():
	hide()
	pass # Replace with function body.


func _on_LineEdit_text_changed(new_text : String):
	if new_text.is_valid_float() and float(new_text) > 0.0:
		beats = float(new_text)
		update_tempo()
	pass # Replace with function body.


func _on_Accept_Button_pressed():
	get_tree().call_group("Song Time Recievers", "recieve_bpm", tempo)
	get_tree().call_group("Song Time Recievers", "recieve_snapping_offset", snapping_offset)
	hide()
	pass # Replace with function body.
