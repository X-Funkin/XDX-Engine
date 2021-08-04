extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_stopped():
		var time = time_left
		get_tree().call_group("Song Time Recievers", "recieve_song_time", -time*1000.0+15.5)
#	pass
