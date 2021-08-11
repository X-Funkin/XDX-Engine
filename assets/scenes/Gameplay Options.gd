extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float, 0.1, 10.0) var scroll_speed = 1.0 setget set_scroll_speed
export(float) var offset = 0.0 setget set_offset
export(int, "Upscroll", "Downscroll") var scroll_direction = 0 setget set_scroll_direction

export(NodePath) var audio_track
export(String, FILE) var metronome_chart
export(NodePath) var note_track
export(NodePath) var hit_indicator_transform
export(NodePath) var left_indicator
export(NodePath) var down_indicator
export(NodePath) var up_indicator
export(NodePath) var right_indicator

export(NodePath) var scroll_speed_label
export(NodePath) var offset_label
export(NodePath) var scroll_direction_text

var changing_scroll_speed = 0
var changing_offset_speed = 0
var changing_speed = 1.0

func set_scroll_speed(n_speed):
	scroll_speed = n_speed
	if not is_inside_tree(): yield(self,"ready")
	var scale_thing = 1.0
	match scroll_direction:
		0:
			scale_thing = 1.0
		1:
			scale_thing = -1.0
	get_node(note_track).scroll_speed = n_speed*scale_thing
	get_node(scroll_speed_label).text = " %2.2f"%n_speed

func set_offset(n_offset):
	offset = n_offset
	if not is_inside_tree(): yield(self,"ready")
	get_node(audio_track).offset_ms = n_offset
	get_node(offset_label).text = " %4.1f ms"%n_offset

func set_scroll_direction(n_direction):
	scroll_direction = n_direction
	if not is_inside_tree(): yield(self, "ready")
	print("yeayaehadsf change scrooool lol")
	var scale_thing = 1.0
	var text_yeah = "upscroll"
	match scroll_direction:
		0:
			scale_thing = 1.0
			text_yeah = "upscroll"
		1:
			scale_thing = -1.0
			text_yeah = "downscroll"
	get_node(note_track).position.y *= scale_thing
	get_node(note_track).scroll_speed *= scale_thing
	get_node(hit_indicator_transform).scale.y = scale_thing
	get_node(scroll_direction_text).text = text_yeah
	pass

func generate_metronome_track():
	var file = File.new()
	file.open(metronome_chart, File.WRITE)
	var chart_data = {"song":{"song":"Metronome","notes":[{"mustHitSection":false,"typeOfSection":0,"lengthInSteps":16,"sectionNotes":[]}]}}
	var beats = 0
	var notes = []
	while beats < 240:
		var time = beats*250
		match beats%8:
			0:
				notes.append([time,0,0])
				notes.append([time,3,0])
			1:
				notes.append([time,1,0])
			2:
				notes.append([time,2,0])
			3:
				notes.append([time,1,0])
			4:
				notes.append([time,3,0])
				notes.append([time,0,0])
			5:
				notes.append([time,2,0])
			6:
				notes.append([time,1,0])
			7:
				notes.append([time,2,0])
		
		beats += 1
	chart_data["song"]["notes"][0]["sectionNotes"] = notes
	file.store_string(JSON.print(chart_data))
	pass

func update_setting(setting, value):
	get_tree().call_group("Setting Recievers", "recieve_setting", setting, value)


func update_settings():
	update_setting("scroll_speed", scroll_speed)
	update_setting("offset_ms", offset)
	update_setting("scroll_direction", 1-2*scroll_direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_metronome_track()
	get_node(note_track).load_chart()
	pass # Replace with function body.

func recieve_enemy_hit(note, hit_error):
	print(note.note_type)
	match note.note_type:
		0:
			get_node(left_indicator).color = Color(1,1,1)
		1:
			get_node(down_indicator).color = Color(1,1,1)
		2:
			get_node(up_indicator).color = Color(1,1,1)
		3:
			get_node(right_indicator).color = Color(1,1,1)

func _input(event):
	if event.is_action_pressed("ui_up"):
		changing_scroll_speed = 1.0
	if event.is_action_pressed("ui_down"):
		changing_scroll_speed = -1.0
	if event.is_action_released("ui_up"):
		changing_scroll_speed = 0
	if event.is_action_released("ui_down"):
		changing_scroll_speed = 0
	
	if event.is_action_pressed("ui_right"):
		changing_offset_speed = 1.0
	if event.is_action_pressed("ui_left"):
		changing_offset_speed = -1.0
	if event.is_action_released("ui_right"):
		changing_offset_speed = 0
	if event.is_action_released("ui_left"):
		changing_offset_speed = 0
	
	if event.is_action_pressed("ui_accept"):
#		var n_direction = 0
		match scroll_direction:
			0:
				self.scroll_direction = 1
			1:
				self.scroll_direction = 0
	
	if event is InputEventKey:
		if event.scancode == KEY_CONTROL and event.is_pressed():
			changing_speed = 0.1
		if event.scancode == KEY_SHIFT and event.is_pressed():
			changing_speed = 3.0
		
		if event.scancode == KEY_CONTROL and !event.is_pressed():
			changing_speed = 1
		if event.scancode == KEY_SHIFT and !event.is_pressed():
			changing_speed = 1
	
	if event.is_action_pressed("ui_cancel"):
		update_settings()
		get_tree().call_group("Options Menu Switchers", "switch_to_main_options")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if changing_scroll_speed != 0:
		print("NOT ZERO")
		self.scroll_speed = clamp(scroll_speed+changing_scroll_speed*changing_speed*delta,0.1,10.0)
	if changing_offset_speed != 0:
		self.offset = offset + changing_offset_speed*changing_speed*delta
	pass
#	pass


func _on_AudioStreamPlayer_finished():
	var thingy_track : ArrowTrack = get_node(note_track)
	for note in thingy_track.get_notes():
		note.spawn()
	pass # Replace with function body.
