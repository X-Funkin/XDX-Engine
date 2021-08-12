extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/FNF Text/Gameplay Options Button".grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("Menu Switchers", "switch_to_main")

func _on_Gameplay_Options_Button_pressed():
	get_tree().call_group("Options Menu Switchers", "switch_to_gameplay_options")
	
	pass # Replace with function body.
