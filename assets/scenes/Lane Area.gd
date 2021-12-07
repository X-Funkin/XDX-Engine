extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var target_track
export(int, "Enemy Track", "Player Track") var track_type
export(int, "Left Lane", "Down Lane", "Up Lane", "Right Lane") var lane_type
export(float) var song_time_cursor = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"GUI Input Area".connect("mouse_entered", self, "_on_GUI_Input_Area_mouse_entered")
	$"GUI Input Area".connect("mouse_exited", self, "_on_GUI_Input_Area_mouse_exited")
	$"GUI Input Area".connect("input_event", self, "_on_GUI_Input_Area_input_event")
	pass # Replace with function body.

func recieve_song_time_cursor(song_time):
	song_time_cursor = song_time

func move_yeah():
#	$noteyah.global_position.y = get_global_mouse_position().y
	pass

func mouse_move():
	move_yeah()

func mouse_entered():
#	$noteyah.visible = true
	move_yeah()
	pass

func mouse_exited():
#	$noteyah.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GUI_Input_Area_mouse_entered():
	mouse_entered()
	get_tree().call_group("Track Input Recievers", "recieve_track_mouse_entered", track_type,lane_type)
#	print("Track Input Recievers", "recieve_track_mouse_entered", track_type,lane_type)
	pass # Replace with function body.


func _on_GUI_Input_Area_mouse_exited():
	mouse_exited()
	get_tree().call_group("Track Input Recievers", "recieve_track_mouse_exited", track_type,lane_type)
#	print("Track Input Recievers", "recieve_track_mouse_exited", track_type,lane_type)
	pass # Replace with function body.


func _on_GUI_Input_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		move_yeah()
	get_tree().call_group("Track Input Recievers", "recieve_track_input",track_type,lane_type, event)
	pass # Replace with function body.
