extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var left_control
export(NodePath) var down_control
export(NodePath) var up_control
export(NodePath) var right_control
var focused_node : NodePath
var current_action = "note_left"
var changing_control = false
# Called when the node enters the scene tree for the first time.
func _ready():
#	$"CenterContainer/VBoxContainer/HBoxContainer".grab_focus()
	get_node(left_control).grab_focus()
#	get_node(left_control).control_text
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("Options Menu Switchers", "switch_to_gameplay_options")
		GameData.save_game_data()
		GameData.load_controls()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HBoxContainer_focus_entered():
	print("adsfjd")
	pass # Replace with function body.


func _on_HBoxContainer2_focus_entered():
	print("ahfsadhfadssss")
	pass # Replace with function body.


func _on_Left_Control_Item_focus_entered():
	current_action = "note_left"
	focused_node = left_control
	pass # Replace with function body.


func _on_Down_Control_Item_focus_entered():
	current_action = "note_down"
	focused_node = down_control
	pass # Replace with function body.


func _on_Up_Control_Item_focus_entered():
	current_action = "note_up"
	focused_node = up_control
	pass # Replace with function body.


func _on_Right_Control_Item_focus_entered():
	current_action = "note_right"
	focused_node = right_control
	pass # Replace with function body.
