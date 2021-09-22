tool
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func resize(size):
	var node = $"Area Shape"
	node.position = size/2.0
	node.shape.extents = size/2.0

func resize_to_parent():
	var parent = get_parent()
	if parent is Control:
		resize(parent.rect_size)

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	if parent is Control:
		parent.connect("resized", self, "resize_to_parent")
		resize_to_parent()
	pass # Replace with function body.

func print_gui_input(event):
	print("GUI INPUT AREA EVENT")
	if event is InputEventKey or event is InputEventMouseButton:
		pass
	print(get_parent().name, " ", event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GUI_Input_Area_input_event(viewport, event, shape_idx):
#	print_gui_input(event)
	pass # Replace with function body.
