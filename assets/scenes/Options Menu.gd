extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var settings_data = GameData.data.settings
var default_settings = {}

export(PackedScene) var main_options
export(PackedScene) var gameplay_options
export(PackedScene) var scrolling_options
export(PackedScene) var control_options
export(PackedScene) var video_options
export(PackedScene) var sound_options
var target_scene : PackedScene

# Called when the node enters the scene tree for the first time.

func load_options_menu():
	save_settings()
	print("yeah switchchhc options")
	print(settings_data)
	for node in $"Current Options Menu".get_children():
		node.queue_free()
	$"Current Options Menu".add_child(target_scene.instance())
	

func switch_to_main_options():
	target_scene = main_options
	load_options_menu()

func switch_to_gameplay_options():
	target_scene = gameplay_options
	load_options_menu()

func switch_to_scrolling_options():
	target_scene = scrolling_options
	load_options_menu()

func switch_to_control_options():
	target_scene = control_options
	load_options_menu()

func switch_to_video_options():
	target_scene = video_options
	load_options_menu()

func switch_to_sound_options():
	target_scene = sound_options
	load_options_menu()

func save_settings():
	GameData.data.settings = settings_data
	GameData.save_game_data()

func recieve_setting(setting, value):
	settings_data[setting] = value

func _ready():
	GameData.data.settings = settings_data
	$Camera2D.current = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
