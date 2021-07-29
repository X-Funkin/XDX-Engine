extends Position2D
class_name NoteLane

export(float) var song_time = 0.0 setget set_song_time, get_song_time

func set_song_time(n_time):
	song_time = n_time
	position.y = -song_time

func get_song_time():
	return song_time

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
