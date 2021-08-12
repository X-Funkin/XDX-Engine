extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var data = {"settings":{},"default_settings":{}}
#var settings = {}
#var default_settings = {}

var game_data_file = "user://../XDX Engine/Game_Data.json"

func load_game_data():
	var file = File.new()
	file.open(game_data_file, File.READ)
	data = JSON.parse(file.get_as_text()).result
	if not data is Dictionary:
		data = {"settings":{},"default_settings":{}}
	pass

func save_game_data():
	var file = File.new()
	file.open(game_data_file, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
