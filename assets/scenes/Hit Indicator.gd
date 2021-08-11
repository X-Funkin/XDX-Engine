extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Color) var identity_color
export(int, "Left", "Down", "Up", "Right") var indicate
var darken_speed = 10.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recieve_enemy_hit(note : Note, hit_error):
	if note.note_type == indicate:
		color = Color(1.0,1.0,1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if color == Color(1.0,1.0,1.0):
		color = identity_color
	else:
		color = color.linear_interpolate(Color(0,0,0), darken_speed*delta)
		pass
	
#	pass
