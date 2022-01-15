extends PopupMenu


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Texture) var yeahtexture
export(int, "Select", "Note") var editor_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("Copy Notes")
	add_item("Paste Notes")
	add_item("Delete Notes")
	add_item("Mirror Notes")
	add_item("Swap Notes")
	add_item("Retime Tempo")
	add_item("Extract Tempo")
#	add_item("testest")
#	add_check_item("wowzers")
#	add_icon_item(yeahtexture, "wowee texture yeah")
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.is_pressed() and editor_mode==0:
			rect_global_position = get_global_mouse_position()
			popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recieve_editor_mode(mode):
	editor_mode = mode


func _on_Right_Click_Menu_id_pressed(id):
#	print(id)
	var op_string = ""
	match id:
		0:
			op_string = "recieve_copy_notes"
		1:
			op_string = "recieve_paste_notes"
		2:
			op_string = "recieve_delete_notes"
		3:
			op_string = "recieve_mirror_notes"
		4:
			op_string = "recieve_swap_notes"
		5:
			op_string = "recieve_retime_notes"
		6:
			op_string = "recieve_extract_tempo"
	get_tree().call_group("Operation Recievers", op_string)
	pass # Replace with function body.
