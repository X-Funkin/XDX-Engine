extends Control


export(Vector2) var cursor_position setget set_cursor_position

func set_cursor_position(n_pos):
	cursor_position = n_pos
	if not is_inside_tree(): yield(self, "ready")
	update_cursor()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func update_cursor():
	$"Editor Cursor".global_position = cursor_position
	$"X Editor Cursor".global_position.x = cursor_position.x
	$"Y Editor Cursor".global_position.y = cursor_position.y

func recieve_editor_cursor(pos):
	self.cursor_position = pos
#	update_cursor()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
