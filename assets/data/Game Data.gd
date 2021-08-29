extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var data = {"settings":{},"default_settings":{},
"controls":{"note_left":[68],"note_down":[70],"note_up":[74],"note_right":[75]}, "volume":{"Master":100}, "photosensitivity":0,
"video_settings":{"window_mode": 0, "resolution": [1920,1080], "framerate": 60, "framerate_max": true, "vsync": true, "fps_overlay": false, "mem_overlay": false}} #

#var window = {"mode": 0, "fullscreen": true, "windowed": false, "windowed_boarderless": false, "resolution":{0:1920,1:1080,"x":1920,"y":1080}}
#var settings = {}
#var default_settings = {}

#var volume = 100.0 setget set_volume

var game_data_file = "user://../XDX Engine/Game_Data.json"

func load_game_data():
	var file = File.new()
	file.open(game_data_file, File.READ)
	var new_data = JSON.parse(file.get_as_text()).result
	if not data is Dictionary:
		data = {"settings":{},"default_settings":{}}
	if new_data is Dictionary:
		for thing in new_data:
			data[thing] = new_data[thing]
	pass

func save_game_data():
	var file = File.new()
	file.open(game_data_file, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

func load_controls():
	for control in data.controls:
		print(control)
		var input_events = InputMap.get_action_list(control)
		for event in input_events:
			InputMap.action_erase_event(control,event)
		for scancode in data.controls[control]:
			var new_event = InputEventKey.new()
			new_event.scancode = scancode
			InputMap.action_add_event(control,new_event)
		
	pass

func update_window_mode():
	match data.video_settings.window_mode:
		0:
			OS.window_fullscreen = true
		1:
			OS.window_fullscreen = false
			OS.window_borderless = false
		2:
			OS.window_fullscreen = false
			OS.window_borderless = true

func update_resolution():
	var resolution = data.video_settings.resolution
	var res = Vector2(resolution[0],resolution[1])
	OS.window_size = res
	get_tree().get_root().size = res
#	get_tree().get_root().set_size_override(true)
#	get_tree().get_root().set_size_override_stretch(true)

func update_vsync():
	var vsync = data.video_settings.vsync
	OS.vsync_enabled = vsync

func update_framerate():
	var fps = data.video_settings.framerate
	var max_fps = data.video_settings.framerate_max
	if !max_fps:
		Engine.target_fps = fps
	else:
		Engine.target_fps = 0
	pass

func update_fps_overlay():
	var overlay_node = get_node_or_null("Performance Overlay/Performance Overlay")
	if not overlay_node:
		var perf_overlay = load("res://assets/scenes/Performance Overlay.tscn").instance()
		var canvas = CanvasLayer.new()
		canvas.name = "Performance Overlay"
		canvas.add_child(perf_overlay)
		add_child(canvas)
		overlay_node = perf_overlay
	overlay_node.show_framerate = GameData.data.video_settings.fps_overlay

func update_mem_overlay():
	var overlay_node = get_node_or_null("Performance Overlay/Performance Overlay")
	if not overlay_node:
		var perf_overlay = load("res://assets/scenes/Performance Overlay.tscn").instance()
		var canvas = CanvasLayer.new()
		canvas.name = "Performance Overlay"
		canvas.add_child(perf_overlay)
		add_child(canvas)
		overlay_node = perf_overlay
	overlay_node.show_memory_usage = GameData.data.video_settings.mem_overlay
#	print("mem test ", GameData.data.video_settings.mem_overlay)
#	print(overlay_node.show_memory_usage)
#	print(overlay_node.visible)

func load_video_settings():
	update_window_mode()
	update_resolution()
	update_framerate()
	update_vsync()
	update_fps_overlay()
	update_mem_overlay()
	pass

func screenshot():
	var image = get_viewport().get_texture().get_data()
	var c_time = "%s-%s-%s-%s_%s_%s"%[OS.get_datetime()["month"],OS.get_datetime()["day"],OS.get_datetime()["year"],OS.get_datetime()["hour"],OS.get_datetime()["minute"],OS.get_datetime()["second"]]
	print(c_time)
	image.flip_y()
	image.save_png("res://screenshots/screenshot_%s.png"%c_time)

func change_volume(volume):
	var volume_node = get_node_or_null("Volume UI/Volume UI")
	if not volume_node:
		var volume_ui = load("res://assets/scenes/Volume UI.tscn").instance()
		var canvas = CanvasLayer.new()
		canvas.name = "Volume UI"
		canvas.add_child(volume_ui)
		add_child(canvas)
		volume_node = volume_ui
	volume_node.change_volume(volume)
	pass



#func set_volume(n_volume):
#	data.volume = volume
#	load_volume()

func load_volume():
	for bus in data.volume:
		print("laoding volume ", bus, " ", data.volume[bus])
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear2db(data.volume[bus]/100.0))
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus)))
		pass
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), data.volume.Master/100.0)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_F12 and event.pressed and !event.is_echo():
			screenshot()
		if event.scancode == KEY_EQUAL and event.pressed:
			data.volume.Master = clamp(data.volume.Master+10.0, 0, 100)
			change_volume(data.volume.Master)
		if event.scancode == KEY_MINUS and event.pressed:
			data.volume.Master = clamp(data.volume.Master-10.0, 0, 100)
			change_volume(data.volume.Master)
		if event.scancode == KEY_F11 and event.pressed:
			load_volume()

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	OS.set_window_title("XDX Engine Alpha 1.4.0")
	load_game_data()
	load_controls()
	load_video_settings()
	load_volume()
#	load_volume()
#	self.volume = data.volume
	pass # Replace with function body.

func _notification(what):
	match what:
		NOTIFICATION_EXIT_TREE:
			save_game_data()
#		NOTIFICATION_READY:
#			load_volume()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
