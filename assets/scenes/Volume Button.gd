extends HBoxContainer

export(String) var audio_bus = "Master"
export(float, 0, 100) var volume = 100.0 setget set_volume
export(bool) var changing = false
export(float,-1,1) var changing_dir = 1.0
export(float) var current_speed = 20
export(float) var slow_speed = 10
export(float) var normal_speed = 20
export(float) var fast_speed = 40
export(float) var focus_pos setget set_focus_pos
export(NodePath) var fnf_button_node

func set_volume(n_volume):
	volume = n_volume
	if not is_inside_tree(): yield(self, "ready")
	$Label.text = ":  %4.0f"%volume+"%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), linear2db(volume/100.0))
	GameData.data.volume[audio_bus] = int(volume)


func set_focus_pos(n_pos):
	focus_pos = n_pos
	if get_parent().has_method("refocus"):
		print("yeah got to the window pos")
		get_parent().focus_pos = n_pos

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(audio_bus))
	self.volume = db2linear(volume_db)*100.0
	$Label.modulate = get_node(fnf_button_node).unfocused_color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if changing:
		current_speed = normal_speed
		if Input.is_key_pressed(KEY_SHIFT):
			current_speed = fast_speed
		if Input.is_key_pressed(KEY_CONTROL):
			current_speed = slow_speed
		self.volume = clamp(volume+current_speed*changing_dir*delta, 0, 100.0)
#	pass


#func _input(event):
#	if event is InputEventKey:
#		if event.scancode == KEY_SHIFT and event.is_pressed():
#			current_speed = fast_speed
#		if event.scancode == KEY_CONTROL and event.is_pressed():
#			current_speed = slow_speed
#		if !event.is_pressed() and (event.scancode in [KEY_SHIFT, KEY_CONTROL]):
#			current_speed = normal_speed


func _on_FNF_Button_focus_entered():
	$Label.modulate = get_node(fnf_button_node).focused_color
	self.focus_pos = rect_position.y
	pass # Replace with function body.


func _on_FNF_Button_focus_exited():
	$Label.modulate = get_node(fnf_button_node).unfocused_color
	pass # Replace with function body.


func _on_FNF_Button_gui_input(event : InputEvent):
	if event.is_action_pressed("ui_right"):
		$"Volume Blip".stop()
		$"Volume Blip".play()
		changing = true
		changing_dir = 1.0
	if event.is_action_pressed("ui_left"):
		$"Volume Blip".stop()
		$"Volume Blip".play()
		changing = true
		changing_dir = -1.0
	if event.is_action_released("ui_right") or event.is_action_released("ui_left"):
		$"Volume Blip".stop()
		$"Volume Blip".play()
		changing = false
	pass # Replace with function body.
