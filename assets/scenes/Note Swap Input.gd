extends TextureRect


export(int, "Left", "Down", "Up", "Right") var note_type
#export(int, "Top", "Bottom") var 
export(NodePath) var main_ui

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", self,"_on_gui_input")
	connect("mouse_entered", self, "_on_mouse_entered")
	pass # Replace with function body.


func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		print(event)
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			print("SELECTED ", name)
			var node = get_node(main_ui)
			node.select_note_type(note_type)
		if event.button_index == BUTTON_LEFT and !event.is_pressed():
			get_node(main_ui).find_target_note(get_global_mouse_position())
#			print("TARGET ", name)

func _on_mouse_entered():
#	if Input.is_mouse_button_pressed(BUTTON_LEFT) or true:
#		print("TARGET ", name)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
