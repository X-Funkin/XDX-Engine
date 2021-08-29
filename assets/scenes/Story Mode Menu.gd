extends Node2D


export(NodePath) var top_text_label
export(NodePath) var week_sprite_node
export(NodePath) var tracks_label
export(PackedScene) var week_button
export(NodePath) var week_button_container
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_week_data = {}

func dir_contents(path, return_full_path = true):
	var contents = {"Files":[],"Folders":[]}
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
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

func get_all_week_data():
	var weeks_data = []
#	print(dir_contents("res://assets/weeks/"))
	var weeks_folder_contents = dir_contents("res://assets/weeks/")
	for folder in weeks_folder_contents["Folders"]:
		var week_contents = dir_contents(folder, false)
		for file in week_contents["Files"]:
			if file == "week_data.json":
				var data_file = File.new()
				data_file.open(folder+file, File.READ)
				var week_data = JSON.parse(data_file.get_as_text()).result
				print("WEEEK DATAAAA")
				print(week_data)
				weeks_data.append(week_data)
	return weeks_data
	pass

func add_week_buttons():
	for node in get_node(week_button_container).get_children():
		node.queue_free()
	var all_week_data = get_all_week_data()
	var count = 0
	for week_data in all_week_data:
		print("trying to load ", week_data["week_menu_image"])
		var week_button_inst : TextureButton = week_button.instance()
		var button_image = Image.new()
		button_image.load(week_data["week_menu_image"])
		var button_texture = ImageTexture.new()
		button_texture.create_from_image(button_image)
		$Test_Sprite.texture = button_texture
		week_button_inst.texture_disabled = button_texture
		week_button_inst.texture_focused = button_texture
		week_button_inst.texture_hover = button_texture
		week_button_inst.texture_normal = button_texture
		week_button_inst.texture_pressed = button_texture
		week_button_inst.week_data = week_data
		get_node(week_button_container).add_child(week_button_inst)
		if count == 0:
			week_button_inst.grab_focus()
		count += 1
		pass
#	get_node(week_button_container).get_child(0).grab_focus()

func update_week_menu():
	if "top_text" in selected_week_data:
		get_node(top_text_label).text = selected_week_data["top_text"]
	for node in get_node(week_sprite_node).get_children():
		node.queue_free()
	if "week_sprite" in selected_week_data:
		if selected_week_data["week_sprite"] != "":
			var sprite = load(selected_week_data["week_sprite"])
			var sprite_inst = sprite.instance()
			get_node(week_sprite_node).add_child(sprite_inst)
			sprite_inst.play_animation("Idle")
	get_node(tracks_label).text = "TRACKS\n"
	if "week_tracks" in selected_week_data:
		var track_string = ""
		for track in selected_week_data["week_tracks"]:
			track_string += "\n"+track
		get_node(tracks_label).text = "TRACKS\n"+track_string.to_upper()
	

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("Menu Switchers", "switch_to_main")
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene(selected_week_data["target_file"])

func _ready():
	$Camera2D.current = true
	var data = get_all_week_data()
	print("okay did it work tho?")
	print(data)
	add_week_buttons()
#	get_node(week_button_container).get_child(0).grab_focus()
	pass # Replace with function body.


func recieve_week_data(week_data):
	selected_week_data = week_data
	update_week_menu()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
