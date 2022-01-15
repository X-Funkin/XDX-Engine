extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func recieve_song_time(song_time):
	get_tree().call_group("Track Visibility Recievers", "recieve_visible_positions", $"Visible Time Start".rect_global_position.y, $"Visible Time End".rect_global_position.y)
	pass
func recieve_zoom(zoom):
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
