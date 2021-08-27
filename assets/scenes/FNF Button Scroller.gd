extends VBoxContainer

export(float) var focus_pos = 0.0 setget set_focus_pos
export(float) var scrolling_speed = 10.0
export(NodePath) var first_option
var start_pos


func set_focus_pos(n_pos):
	focus_pos = n_pos
	if not is_inside_tree(): yield(self, "ready")
	print("yup got all the way up ", focus_pos)

func refocus():
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = rect_position
#	get_child(0).grab_focus()
#	$"FNF Button".grab_focus()
	get_node(first_option).grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position = rect_position.linear_interpolate(start_pos-Vector2(0,focus_pos), scrolling_speed*delta)
#	pass
