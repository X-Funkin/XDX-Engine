extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var note_track = null
func recieve_note_track(n_note_track : NoteTrack):
	print("NOTE TRACK RECIEVEREDDDD")
	if n_note_track.player_track:
		note_track = n_note_track
		var dupe_track = note_track.duplicate(DUPLICATE_USE_INSTANCING)
		$track.add_child(dupe_track)
		print(note_track)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
