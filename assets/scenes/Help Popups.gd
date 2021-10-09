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


func _on_Help_Button_pressed():
	$Help.popup()
	pass # Replace with function body.


func _on_Controls_Button_pressed():
	$Controls.popup()
	pass # Replace with function body.


func _on_How_To_Button_pressed():
	$"How To".popup()
	pass # Replace with function body.
