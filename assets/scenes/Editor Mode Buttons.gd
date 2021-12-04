extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Select_Mode_Button_toggled(button_pressed):
	if button_pressed:
		get_tree().call_group("Note Editor Mode Recievers", "recieve_editor_mode", 0)
		$"Note Mode Button".pressed = false
	pass # Replace with function body.


func _on_Note_Mode_Button_toggled(button_pressed):
	if button_pressed:
		get_tree().call_group("Note Editor Mode Recievers", "recieve_editor_mode", 1)
		$"Select Mode Button".pressed = false
	pass # Replace with function body.
