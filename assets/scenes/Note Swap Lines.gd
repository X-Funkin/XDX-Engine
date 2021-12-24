extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(bool) var selecting
export(int, "Left", "Down", "Up", "Right") var selected_note
export(int, "Left", "Down", "Up", "Right") var target_note
export(Array, int) var remap_array = [0,1,2,3]
export(Array, NodePath) var top_notes
export(Array, NodePath) var bottom_notes
export(NodePath) var main_ui
var color_array = [Color.magenta, Color.cyan, Color.green, Color.red]

#export(NodePath) var note_swap_lines

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_node(main_ui), "ready")
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion and selecting:
		update()
#		pass

func _draw():
	if top_notes and bottom_notes:
		for indx in range(remap_array.size()):
			var first_note : TextureRect = get_node(top_notes[indx])
			var second_note : TextureRect = get_node(bottom_notes[remap_array[indx]])
#			print(indx)
#			print(remap_array)
#			print(top_notes)
#			print(bottom_notes)
#			print(first_note)
#			print(second_note)
#			print(top_notes[indx])
#			print(bottom_notes[remap_array[indx]])
#			print(top_notes[indx] is NodePath)
#			print(bottom_notes[remap_array[indx]] is NodePath)
			var first_pos = first_note.rect_global_position+first_note.rect_size*Vector2(0.5,1.0)
			var second_pos = second_note.rect_global_position+second_note.rect_size*Vector2(0.5,0.0)
			if second_note.note_type == selected_note and selecting:
				second_pos = get_global_mouse_position()
			first_pos += -rect_global_position
			second_pos += -rect_global_position
			
			var first_color = color_array[indx]
			var second_color = color_array[remap_array[indx]]
#			draw_line(first_pos-rect_global_position,second_pos-rect_global_position, Color.white, 10)
#			draw_multiline_colors([first_pos-rect_global_position,second_pos-rect_global_position], [first_color,second_color], 10)
			draw_circle(first_pos,5,first_color)
			draw_circle(second_pos,5,second_color)
			draw_polyline_colors([first_pos,second_pos], [first_color,second_color], 10)
			pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
