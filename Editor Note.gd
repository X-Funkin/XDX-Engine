extends Note
class_name EditorNote


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Area2D".connect("mouse_entered", self, "mouse_entered")
	$"Area2D".connect("mouse_exited", self, "mouse_exited")
	$"Area2D".connect("input_event", self, "input_event")
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
		if get_parent().song_time < hit_time:
			spawn()
