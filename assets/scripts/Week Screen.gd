extends GameWeek

export(Texture) var week_menu_image
export(String, FILE) var week_sprite
export(Texture) var easy_image
export(Texture) var normal_image
export(Texture) var hard_image
export(PackedScene) var target_scene
export(String, FILE) var target_string
export(String, FILE) var song_data_file
export(String, FILE) var week_data_file

# Declare member variables here. Examples:.
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func get_tracks():
	var tracks = []
	var file = File.new()
	file.open(song_data_file, File.READ)
	var song_data = JSON.parse(file.get_as_text()).result
	for song in song_data["songs"]:
		if "song_name" in song_data["songs"][song]:
			tracks.append(song_data["songs"][song]["song_name"])
	print(tracks)
	return tracks
	pass

func save_week_data():
	var file = File.new()
	file.open(week_data_file, File.WRITE)
	var save_data = {}
	save_data["week_name"] = week_name
	save_data["top_text"] = TOP_TEXT
	save_data["week_menu_image"] = week_menu_image.resource_path
	save_data["week_sprite"] = week_sprite
	save_data["easy_image"] = easy_image.resource_path
	save_data["normal_image"] = normal_image.resource_path
	save_data["hard_image"] = hard_image.resource_path
	save_data["song_data_file"] = song_data_file
	save_data["target_file"] = filename
	save_data["week_tracks"] = get_tracks()
	print(JSON.print(save_data))
	file.store_string(JSON.print(save_data))
	file.close()

func load_scene():
#	print("bruuuh")
	var loader = ResourceLoader.load_interactive(target_string)
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
#			print("ONDE")
			var resource = loader.get_resource()
			get_tree().change_scene_to(resource)
#			get_tree().get_root().call_deferred("add_child", resource.instance())
#			queue_free()
			break
		if err == OK:
#			print("yeah still loading")
			var progress = float(loader.get_stage())/loader.get_stage_count()
			$TextureProgress.value = progress*100
			$Label.text = "%s"%int(progress*100) + " %"
			print(progress)
		yield(get_tree(),"idle_frame")
#		print("i dol frames")
func _ready():
	save_week_data()
	$AnimationPlayer.play("spin")
	if GameData.state.freeplay:
		target_string = GameData.state.song_path
	load_scene()
	pass # Replace with function body.
#
#func _input(event):
##	if event.is_action_pressed("ui_accept"):
##		print("yeayeayh")
##		get_tree().change_scene(tar1get_string)
#	load_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
