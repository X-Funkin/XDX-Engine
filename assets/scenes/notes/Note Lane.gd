extends Position2D
class_name NoteLane

export(float) var song_time = 0.0 setget set_song_time, get_song_time
export(float) var timing_window = 120.0
export(int, "Left", "Down", "Up", "Right") var lane_type
export(bool) var holding_note setget set_holding_note
var held_note : HoldNote setget set_held_note

func set_song_time(n_time):
	song_time = n_time
	position.y = -song_time
	if held_note:
		held_note.check_holding()

func get_song_time():
	return song_time


signal holding_note(holding)
func set_holding_note(n_holding : bool):
	emit_signal("holding_note", n_holding)
	holding_note = n_holding

func set_held_note(n_held_note):
	held_note = n_held_note
	pass

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
