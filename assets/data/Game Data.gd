extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var data = {"settings":{},"default_settings":{},
"controls":{"note_left":[68],"note_down":[70],"note_up":[74],"note_right":[75]}, "volume":{"Master":100}, "photosensitivity":0,
"video_settings":{"window_mode": 0, "resolution": [1920,1080], "framerate": 60, "framerate_max": true, "vsync": true, "fps_overlay": false, "mem_overlay": false}} #

var state = {"playstate": 0, "story": true, "freeplay": false, "song_path": ""}
#var window = {"mode": 0, "fullscreen": true, "windowed": false, "windowed_boarderless": false, "resolution":{0:1920,1:1080,"x":1920,"y":1080}}
#var settings = {}
#var default_settings = {}

#var volume = 100.0 setget set_volume

var version = ["Alpha", 1, 4, 7]
var game_data_file = "user://../XDX Engine/Game_Data_%s-%s.%s.%s.json"%version

#func load_data_file(path)

func load_game_data():
	print("Loading Game Data...")
	var file = File.new()
	if file.file_exists(game_data_file):
		print("File Exists")
		file.open(game_data_file, File.READ)
		var new_data = JSON.parse(file.get_as_text()).result
		if not data is Dictionary:
			data = {"settings":{},"default_settings":{}}
		if new_data is Dictionary:
			for thing in new_data:
				data[thing] = new_data[thing]
		pass
	else:
		print("File Doesn't Exist")
		var dir = Directory.new()
		var files = []
		if dir.open("user://../XDX Engine/") == OK:
			print("dir.open == okayyy")
			dir.list_dir_begin(true)
			var file_name = dir.get_next()
			while file_name != "":
				if !dir.current_is_dir():
					if file_name.split(".")[-1] == "json":
						files.append(file_name)
						print(file_name)
				file_name = dir.get_next()
		if files != []:
			print("files != []")
			var newest_file = ["", 0]
			for data_file in files:
#				file.open(data_file, File.READ)
				var modify_time = file.get_modified_time(data_file)
				if modify_time > newest_file[1]:
					newest_file = [data_file, modify_time]
			if newest_file != ["", 0]:
				file.open(newest_file)
				var new_data = JSON.parse(file.get_as_text()).result
				if new_data is Dictionary:
					for thing in new_data:
						if typeof(data[thing]) == typeof(new_data[thing]):
							data[thing] = new_data[thing]

func save_game_data():
	var file = File.new()
	file.open(game_data_file, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

func load_controls():
	print("Loading Controls")
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

func toggle_debug_console():
	var debug_console = get_node_or_null("Console Overlay/Console Overlay")
	if not debug_console:
		var console_overlay = load("res://assets/scenes/Console Overlay.tscn").instance()
		var canvas = CanvasLayer.new()
		canvas.name = "Console Overlay"
		canvas.add_child(console_overlay)
		add_child(canvas)
		console_overlay.visible = false
		debug_console = console_overlay
	debug_console.visible = !debug_console.visible
	pass

func load_video_settings():
	print("Loading Video Settings...")
	update_window_mode()
	update_resolution()
	update_framerate()
	update_vsync()
	update_fps_overlay()
	update_mem_overlay()
	pass

func reset_gamestate():
	var default_state = {"playstate": 0, "story": true, "freeplay": false, "song_path": ""}
	for thing in default_state:
		state["thing"] = default_state["thing"]

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
	print("Loading Volumes...")
	for bus in data.volume:
		print("laoding volume ", bus, " ", data.volume[bus])
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear2db(data.volume[bus]/100.0))
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus)))
		pass
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), data.volume.Master/100.0)

func print_debug_info():
#	print_debug()
	print("\n\n\n","#".repeat(20),"\n","DEBUG PRINT STATEMENT\n","#".repeat(20),"\n")
	print("SYSTEM DATE (MM/DD/YYYY): {month}/{day}/{year}".format(OS.get_datetime()))
	print("SYSTEM CLOCK: {hour}:{minute}:{second}".format(OS.get_time()))
	print("SYSTEM UNIX TIME: ", OS.get_unix_time())
	print("UP TIME (MICROSECONDS): ", OS.get_ticks_usec())
	print("MEMORY USAGE (BYTES): ", Performance.get_monitor(Performance.MEMORY_STATIC))
	print("FRAME RATE (FPS): ", Performance.get_monitor(Performance.TIME_FPS))
	print("OBJECTS: ", Performance.get_monitor(Performance.OBJECT_COUNT))
	print("NODES: ", Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	print("ORPHAN NODES: ", Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	print("RESOURCES: ", Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT))
	print("DRAW CALLS: ", Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME))
	print("VIDEO MEMORY USAGE: ", Performance.get_monitor(Performance.RENDER_USAGE_VIDEO_MEM_TOTAL))
	print("\n\n\n")

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
#			load_volume()
			print_debug_info()
		if event.scancode == KEY_T and Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_ALT) and event.pressed:
			toggle_debug_console()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting...l")
	pause_mode = Node.PAUSE_MODE_PROCESS
	OS.set_window_title("XDX Engine %s %s.%s.%s"%version)
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
			print("EXITING_SCENE_TREE")
			save_game_data()
#		NOTIFICATION_READY:
#			load_volume()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
