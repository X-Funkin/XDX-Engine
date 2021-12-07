extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(int, "Enemy Note Set", "Player Note Set") var note_set_type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recieve_editor_cursor(cursor_pos):
#	print("yeah ", cursor_pos)
	self.global_position.y = cursor_pos.y

func recieve_track_mouse_entered(track_type, lane_type):
#	print("eyahdsahfsad ", track_type, lane_type)
	if track_type == note_set_type:
		match lane_type:
			0:
				$"Default Note Set/Left Note".visible = true
			1:
				$"Default Note Set/Down Note".visible = true
			2:
				$"Default Note Set/Up Note".visible = true
			3:
				$"Default Note Set/Right Note".visible = true

func recieve_track_mouse_exited(track_type, lane_type):
#	print("BMBMABNABASDJFSHSHHHEEDASSA AH", track_type, lane_type)
	if track_type == note_set_type:
		match lane_type:
			0:
				$"Default Note Set/Left Note".visible = false
			1:
				$"Default Note Set/Down Note".visible = false
			2:
				$"Default Note Set/Up Note".visible = false
			3:
				$"Default Note Set/Right Note".visible = false

func recieve_editor_mode(mode):
	match mode:
		0:
			visible = false
		1:
			visible = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
