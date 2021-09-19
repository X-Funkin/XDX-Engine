extends Control
class_name NoteEditor

export(float) var song_time = 0.0
export(float) var zoom = 1.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_control_children(control_node):
	var children = []
	for node in control_node.get_children():
		if node.get_child_count() > 0:
			children.append_array(get_control_children(node))
		if node is Control:
			children.append(node)
	return children

func un_mouse_input_lol():
	for child in get_control_children(self):
		child.mouse_filter = MOUSE_FILTER_IGNORE

func connect_all_control_signals(connect_signal, connect_function):
	var script = load("res://assets/scenes/GUI Input Test.gd")
	for child in get_control_children(self):
		child.connect(connect_signal, self, connect_function)
		if child.get_script() == null:
			child.set_script(script)
#			child.connect("gui_input", child, "print_gui_input")
#			set_script()
			pass
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_all_control_signals("gui_input", "print_gui_input")
	un_mouse_input_lol()
	pass # Replace with function body.


func print_gui_input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		print(event)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
