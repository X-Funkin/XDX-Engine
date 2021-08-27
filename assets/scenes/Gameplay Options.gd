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

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("Options Menu Switchers", "switch_to_main_options")

func _on_Scrolling_and_Offset_Button_pressed():
	get_tree().call_group("Options Menu Switchers", "switch_to_scrolling_options")
	pass # Replace with function body.


func _on_Controls_Button_pressed():
	get_tree().call_group("Options Menu Switchers", "switch_to_control_options")
	pass # Replace with function body.
