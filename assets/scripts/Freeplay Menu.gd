extends Node2D


export(NodePath) var button_container
export(PackedScene) var freeplay_button
var current_song_data = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func dir_contents(path, return_full_path = true):
	var contents = {"Files":[],"Folders":[]}
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
#				print("Found directory: " + file_name)
				if return_full_path:
					contents["Folders"].append(path+file_name+"/")
				else:
					contents["Folders"].append(file_name)
			else:
#				print("Found file: " + file_name)
				if return_full_path:
					contents["Files"].append(path+file_name)
				else:
					contents["Files"].append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return contents



func get_all_song_data():
	var songs_data = []
#	print(dir_contents("res://assets/weeks/"))
	var weeks_folder_contents = dir_contents("res://assets/weeks/")
	for folder in weeks_folder_contents["Folders"]:
		var week_contents = dir_contents(folder, false)
		for file in week_contents["Files"]:
			if file == "song_data.json":
				var data_file = File.new()
				data_file.open(folder+file, File.READ)
				var song_data = JSON.parse(data_file.get_as_text()).result
				print("SONNNNG DATAAAA")
				print(song_data)
				songs_data.append(song_data)
	return songs_data
	pass

func add_week_buttons():
	print("\n\nadding week butotns")
	for node in get_node(button_container).get_children():
		node.queue_free()
	var all_song_data = get_all_song_data()
	var first = true
	for songs in all_song_data:
		for song in songs["songs"]:
			var song_data = songs["songs"][song]
			print("\nsong ", song, " ", song_data)
			var button = freeplay_button.instance()
			button.text = song_data["song_name"]
			button.freeplay_icon = load(song_data["freeplay_icon"])
			button.song_data = song_data
#			if get_node(button_container).get_child_count() == 0:
#				button.grab_focus()
			get_node(button_container).add_child(button)
			if first:
				first = false
				button.grab_focus()
#			button.grab_focus()
#	if get_node(button_container).get_child_count() != 0:
#		var node = get_node(button_container).get_child(0)
#		print(node.name)
#		print(node.get_path())
##		node.grab_focus()
#		get_node(button_container).first_option = node.get_path()
##		node.grab_focus()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(current_song_data)
		pass
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("Menu Switchers", "switch_to_main")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.current = true
	add_week_buttons()
	GameData.state.playstate = 1
	GameData.state.freeplay = true
	GameData.state.story = false
	pass # Replace with function body.

func recieve_song_data(song_data):
	current_song_data = song_data
	if "instrumentals" in current_song_data:
		get_tree().call_group("Menu Switchers", "change_background_track", current_song_data["instrumentals"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
