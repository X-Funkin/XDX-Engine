extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	print("yeah ", name)
	connect("gui_input", self, "print_gui_input")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", self, "print_gui_input")
	pass # Replace with function body.


func print_gui_input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		pass
	print(name," ", event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
