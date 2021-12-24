extends WindowDialog


export(int, "Left", "Down", "Up", "Right") var selected_note
export(int, "Left", "Down", "Up", "Right") var target_note
export(Array, int) var remap_array = [0,1,2,3]
export(Array, NodePath) var top_notes
export(Array, NodePath) var bottom_notes
export(NodePath) var note_swap_lines
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	popup()
	var line_node = get_node(note_swap_lines)
#	line_node.top_notes = top_notes
#	line_node.bottom_notes = bottom_notes
	line_node.remap_array = remap_array
	pass # Replace with function body.

func select_note_type(n_type):
	selected_note = n_type
	print(selected_note)
	var line_node = get_node(note_swap_lines)
	line_node.selected_note = selected_note
	line_node.selecting = true

func target_note_type(n_type):
	target_note = n_type
	print("target note type ", target_note)
	swap_connections()

func find_target_note(pos):
	var note_array = []
	note_array.append_array(top_notes)
	note_array.append_array(bottom_notes)
	for note in note_array:
		if get_node(note).get_global_rect().has_point(pos):
			target_note_type(get_node(note).note_type)
			break
		pass
#		if (pos-note.rect_global_position) in range(0.0,note.rect_size.x):
#			pass

func swap_connections():
	print("SWAPPING CONNECTIONS ")
	print(remap_array)
	var selected_index = remap_array.find(selected_note)
	var target_index = remap_array.find(target_note)
#	print() 
	remap_array[selected_index] = target_note
	remap_array[target_index] = selected_note
	var line_node = get_node(note_swap_lines)
	line_node.remap_array = remap_array
	line_node.selecting = false
	line_node.update()
	pass

#func _draw():
#	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recieve_swap_notes():
	rect_global_position = get_global_mouse_position()-rect_size/2.0
	popup()
#	popup_centered()


func _on_Cancel_Button_pressed():
	hide()
	pass # Replace with function body.


func _on_Accept_Button_pressed():
	get_tree().call_group("Operation Recievers", "recieve_swap_notes_array", remap_array)
	hide()
	pass # Replace with function body.
