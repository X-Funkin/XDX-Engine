extends WindowDialog

export(float) var from_bpm = 100
export(float) var to_bpm = 100


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recieve_retime_notes():
	rect_global_position = get_global_mouse_position()-rect_size/2.0
	popup()
	pass


func _on_From_BPM_Line_Edit_text_entered(new_text : String):
	if new_text.is_valid_float():
		from_bpm = float(new_text)
	pass # Replace with function body.


func _on_To_BPM_Line_Edit_text_entered(new_text : String):
	if new_text.is_valid_float():
		to_bpm = float(new_text)
	pass # Replace with function body.


func _on_Cancel_Button_pressed():
	hide()
	pass # Replace with function body.


func _on_Apply_Button_pressed():
	if to_bpm != 0.0:
		get_tree().call_group("Operation Recievers", "recieve_retime_notes_scale", from_bpm/to_bpm)
	hide()
	pass # Replace with function body.
	


func _on_From_BPM_Line_Edit_text_changed(new_text):
	if new_text.is_valid_float():
		from_bpm = float(new_text)
	pass # Replace with function body.


func _on_To_BPM_Line_Edit_text_changed(new_text):
	if new_text.is_valid_float():
		to_bpm = float(new_text)
	pass # Replace with function body.
