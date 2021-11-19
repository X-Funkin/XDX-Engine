extends Node2D
class_name MenuScreens

export(PackedScene) var start_screen
export(PackedScene) var main_menu
export(PackedScene) var story_mode_menu
export(PackedScene) var freeplay_menu
export(PackedScene) var options_menu
export(String, FILE) var menu_data_file

var target_scene : PackedScene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func fade_in(direction):
	$"Transistion Animations".play("%s Fade In"%direction)

func fade_out(direction):
	$"Transistion Animations".play("%s Fade Out"%direction)

func save_current_menu():
	var file = File.new()
	file.open(menu_data_file, File.READ_WRITE)
	var menu_data = JSON.parse(file.get_as_text()).result
	if menu_data:
		if "menu_path" in menu_data:
			menu_data["menu_path"] = target_scene.resource_path
			file.store_string(JSON.print(menu_data))
			file.close()

func load_previous_menu():
	var file = File.new()
	file.open(menu_data_file, File.READ_WRITE)
	var menu_data_parse = JSON.parse(file.get_as_text())
	if menu_data_parse.error == OK:
		var menu_data = menu_data_parse.result
		if "menu_path" in menu_data:
			if menu_data["menu_path"] != "":
				target_scene = load(menu_data["menu_path"])
				if target_scene:
					load_menu()
	else:
#		file.get_buffer()
#		var asfjdkeuyr = file.get_as_text()
#		file.store_string('{menu_path:""}')
		file.close()
		file.open(menu_data_file, File.WRITE)
		file.store_string('{"menu_path":""}')
		file.close()

func load_menu():
	for node in $"Current Menu".get_children():
		node.queue_free()
	$"Current Menu".add_child(target_scene.instance())
	fade_in("Up")
	save_current_menu()

# Called when the node enters the scene tree for the first time.
var started = false
func start():
	if !started:
		started = true
		$"Current Menu".add_child(start_screen.instance())
		$"Audio Animations".play("Fade In")
		$"Background Music".play()
#func _input(event):
#	if event.is_action_pressed("note_left"):
#		start()
func _ready():
#	GameData.load_volume()
	$"Transistion Animations".play("Default")
	$"Current Menu".add_child(start_screen.instance())
	$"Audio Animations".play("Fade In")
	$"Background Music".play()
	load_previous_menu()
#	$"Transistion Animations".play("Default")
#	$"Current Menu".add_child(start_screen.instance())
#	$"Audio Animations".play("Fade In")
#	$"Background Music".play()
	pass # Replace with function body.

func switch_to_start():
	target_scene = start_screen
	fade_out("Up")

func switch_to_main():
	target_scene = main_menu
	fade_out("Up")

func switch_to_story():
	target_scene = story_mode_menu
	fade_out("Up")

func switch_to_freeplay():
	target_scene = freeplay_menu
	fade_out("Up")

func switch_to_options():
	target_scene = options_menu
	fade_out("Up")

func fade_out_background_track():
	$"Audio Animations".play("Fade Out")

func fade_in_background_track(speed = 1.0):
	$"Audio Animations".playback_speed = speed
	$"Audio Animations".play("Fade In")
	pass

func change_background_track(n_track):
	var n_stream = load(n_track)
	if n_stream is AudioStream:
		fade_in_background_track(3.0)
		$"Background Music".stop()
		$"Background Music".stream = n_stream
		$"Background Music".play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _notification(what):
	match what:
		NOTIFICATION_INSTANCED:
			print("yeahyeahyeahhhhh")

func _on_Transistion_Animations_animation_finished(anim_name):
	if anim_name == "Down Fade Out" or anim_name == "Up Fade Out":
		load_menu()
	pass # Replace with function body.
