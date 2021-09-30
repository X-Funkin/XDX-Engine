extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func recieve_track_mouse_entered(track_type, lane_type):
	visible = (track_type != 3)
	match lane_type:
		0:
			default_color = Color.magenta
		1:
			default_color = Color.cyan
		2:
			default_color = Color.green
		3:
			default_color = Color.red
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
