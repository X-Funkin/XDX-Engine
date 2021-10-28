extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var started = false
func _process(delta):
	if !started:
		get_tree().call_group("Song Time Recievers", "recieve_song_time", -time_left*1000.0)
#	pass


func _on_Timer_timeout():
	started = true
	pass # Replace with function body.
