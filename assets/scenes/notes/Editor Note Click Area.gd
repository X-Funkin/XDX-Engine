extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var note_track
export(NodePath) var note
export(float) var song_time

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("oh wonderfull i, a humble Editor Note Click Area, have been added to here")
	var node = get_node_or_null(note)
	if node:
		node.click_area = self.get_path()
		song_time = node.hit_time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var node = get_node_or_null(note_track)
	if node != null:
		if abs(node.cursor_time-song_time)>1000.0:
			deactiveate()
	else:
		deactiveate()
#	pass

func hover():
	var node = get_node_or_null(note)
	if node:
		node.modulate = Color.yellow
	pass

func unhover():
	var node = get_node_or_null(note)
	if node:
		if node.selected:
			node.modulate = Color.skyblue
		else:
			node.modulate = Color.white
	pass

func deactiveate():
#	print("and with that I, ", self, " am gone, no more, not to be seen on the face of this earth again")
	unhover()
	queue_free()

func _on_Area2D_mouse_entered():
	hover()
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	unhover()
	pass # Replace with function body.


func _on_Area2D_input_event(viewport, event, shape_idx):
	var editor_note_track = get_node_or_null(note_track)
	var editor_note = get_node_or_null(note)
	if editor_note_track:
		match editor_note_track.editor_mode:
			0:
				if event is InputEventMouseButton:
					if event.button_index == BUTTON_LEFT and event.is_pressed():
						if Input.is_key_pressed(KEY_SHIFT):
							if editor_note and editor_note_track:
								editor_note_track.call("select_notes", editor_note)
						elif !Input.is_key_pressed(KEY_CONTROL):
							get_tree().call_group("Selected Notes", "set_selected", false)
						if editor_note and editor_note_track:
							editor_note.selected = true
					
				pass
			1:
				if event is InputEventMouseButton:
					if event.button_index == BUTTON_RIGHT and event.is_pressed():
						
						if editor_note and editor_note_track:
							editor_note_track.delete_note(editor_note)
	pass # Replace with function body.
