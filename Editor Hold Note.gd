extends HoldNote
class_name EditorHoldNote

export(NodePath) var hold_note_input_area
export(int, "Enemy Note", "Player Note") var editor_note_type
export(NodePath) var click_area
export(bool) var selected setget set_selected

func set_selected(n_selected):
	selected = n_selected
	if selected:
		add_to_group("Selected Notes")
		modulate = Color.skyblue
	else:
		if is_in_group("Selected Notes"):
			remove_from_group("Selected Notes")
		modulate = Color.white
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func delete():
	get_tree().call_group("Note Delete Recievers", "recieve_delete_note", self)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
#	get_node(hold_note_input_area).connect("mouse_entered", self, "mouse_entered")
#	get_node(hold_note_input_area).connect("mouse_exited", self, "mouse_exited")
#	get_node(hold_note_input_area).connect("input_event", self, "input_event")
	pass # Replace with function body.


#func check_active():
#	var song_time = get_parent().song_time
#	if !active:
#		if hit_time < song_time:
#			spawn()
#	else:
#		if hit_time > song_time:
#			despawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	check_active()
#	var song_time = get_parent().song_time
#	var timing_window = get_parent().timing_window
#	if !active:
#		if hit_time < song_time-timing_window:
#			spawn()
#	if active:
#		if player_note:
##			print("adjfd")
#			check_scorability()
#		else:
#			check_auto_play()
	
#	check_active()
#	if !active:
#
#	pass


func mouse_entered():
	modulate = Color.yellow

func mouse_exited():
	modulate = Color.white

#func input()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			print("yeah lets try delete note lol")
			queue_free()
	pass # Replace with function body.


func _process(delta):
#	check_active()
	if active:
		if player_note:
#			print("adjfd")
			check_scorability()
		else:
			check_auto_play()
	if !active:
		if get_parent().song_time < hit_time+hold_time:
			spawn()
			update_scale()
	if get_parent().song_time < hit_time-1000.0:
			set_process(false)
	if get_parent().song_time > hit_time+hold_time+150:
		visible = false
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
