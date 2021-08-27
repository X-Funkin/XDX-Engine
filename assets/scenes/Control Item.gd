extends HBoxContainer

export(Color) var focused_color = Color(1,1,1,1)
export(Color) var unfocused_color = Color(1,1,1,0.5)
export(Texture) var focused_texture
export(Texture) var unfocused_texture
export(String) var control_text setget set_control_text
export(String) var padding_text = ":   "
export(String) var control_key setget set_control_key
export(int) var control_scancode setget set_control_scancode
export(String) var control_action
var changing_control = false setget set_changing_control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func set_control_text(n_text):
	control_text = n_text
	if not is_inside_tree(): yield(self,"ready")
	$"FNF Text".text = n_text
	$"FNF Text".update_rect()

func set_control_key(n_key):
	control_key = n_key
	if not is_inside_tree(): yield(self, "ready")
	$Label.text = padding_text+n_key
#	$"FNF Text".text = n_text
#	$Label.text = padding_text+OS.get_scancode_string(n_key)

func set_control_scancode(n_scancode):
	control_scancode = n_scancode
	if not is_inside_tree(): yield(self, "ready")
	self.control_key = OS.get_scancode_string(n_scancode)
	GameData.data.controls[control_action][0] = n_scancode

func set_changing_control(n_changing):
	changing_control = n_changing
	if not is_inside_tree(): yield(self, "ready")
	if changing_control:
		self.control_key = "???"
	else:
		self.control_key = OS.get_scancode_string(control_scancode)
# Called when the node enters the scene tree for the first time.
func _ready():
#	modulate = unfocused_color
#	$Label.text = ""
	print("\nready ", name)
	self.control_text = control_text
	self.control_text = control_text
	print(GameData.data.controls[control_action][0])
	print(GameData.data.controls)
	print(control_scancode)
	print(control_key)
	print($Label.text)
	self.control_scancode = GameData.data.controls[control_action][0]
	self.changing_control = false
	self.control_key = OS.get_scancode_string(control_scancode)
	print(control_scancode)
	self.control_key = OS.get_scancode_string(control_scancode)
	print(control_key)
	print($Label.text)
	unfocused()
	connect("focus_entered", self,"focused")
	connect("focus_exited",self,"unfocused")
	pass # Replace with function body.



func focused():
	modulate = focused_color
	$TextureRect.texture = focused_texture
	self.control_key = OS.get_scancode_string(control_scancode)
	pass

func unfocused():
	modulate = unfocused_color
	$TextureRect.texture = unfocused_texture
	self.changing_control = false
	self.control_key = OS.get_scancode_string(control_scancode)
	pass

func _gui_input(event):
	print(event.is_pressed())
	print(event.as_text())
	print(self.name)
	if changing_control:
		if event is InputEventKey and event.is_pressed():
			if event.scancode in range(32,255) or event.scancode in range(16777345,16777359):
				print(OS.get_scancode_string(event.scancode))
				self.control_scancode = event.scancode
				find_next_valid_focus().grab_focus()
				if find_next_valid_focus().name != "Left Control Item":
					find_next_valid_focus().changing_control = true
	if event.is_action_pressed("ui_accept"):
		self.changing_control = true
		print("yeah ui accepted")
	if event.is_action_pressed("ui_cancel"):
		self.changing_control = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
