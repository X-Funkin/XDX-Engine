extends Control

var chart_data : Dictionary
var preview_data : Dictionary
var note_array_keys = []
var player_note_array = []
var enemy_note_array = []
var note_data_array = []
var note_section_data = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_keys_from_string(string : String, seperator:String = ":"):
	if string == "":
		note_array_keys = []
		return 0
	var str_arr = string.split(seperator, false)
	note_array_keys = str_arr

func change_nested_key(dict, key_arr, new_thing):
	var temp_dict = dict
	var final_key
	for key in key_arr:
		final_key = key
		if temp_dict.has(key):
			if temp_dict[key] is Dictionary:
				temp_dict = temp_dict[key]
			else:
				break
		else:
			break
	temp_dict[final_key] = new_thing

func get_nested_value(dict, key_arr):
	var temp_dict = dict
	var final_key
	for key in key_arr:
		final_key = key
		if temp_dict.has(key):
			if temp_dict[key] is Dictionary:
				temp_dict = temp_dict[key]
			else:
				break
		else:
			break
	if temp_dict.has(final_key):
		return temp_dict[final_key]

func preview_array_setup():
	if !note_array_keys.empty():
		preview_data = chart_data.duplicate(true)
		change_nested_key(preview_data, note_array_keys, ["NOTES WILL GO HERE"])
		$Control/TextEdit.text = JSON.print(preview_data, "\t")
	else:
		preview_data = chart_data.duplicate(true)
		$Control/TextEdit.text = JSON.print(preview_data, "\t")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

class NoteDataSorter:
	static func sort_hit_times(a,b):
		return a[0]<b[0]

func fill_note_data_array():
	note_data_array = []
	for note in player_note_array:
		var data = note.get_data()
		data[1] += 4
		note_data_array.append(data)
	for note in enemy_note_array:
		var data = note.get_data()
		note_data_array.append(data)
	note_data_array.sort_custom(NoteDataSorter, "sort_hit_times")
	pass

func fill_note_section_array(bpm=120):
	note_section_data = []
	var section_length = 0.5*1000.0*8*60.0/bpm
	var section_count = 0
	if note_data_array != []:
		var end_time = note_data_array[-1][0]
		section_count = int(ceil(end_time/section_length)+1)
	for i in range(section_count):
		note_section_data.append({"mustHitSection":false,"typeOfSection":0,"lengthInSteps":16,"sectionNotes":[]})
	for note in note_data_array:
		var note_time = note[0]
		var section_index = int(floor(note_time/section_length))
		note_section_data[section_index]["sectionNotes"].append(note)
#		note_section_data[int(floor())
	pass

func export_chart(path):
	fill_note_data_array()
	if "bpm" in chart_data["song"]:
		fill_note_section_array(chart_data["song"]["bpm"])
		change_nested_key(chart_data, note_array_keys, note_section_data)
		var file = File.new()
		file.open(path, File.WRITE)
		file.store_string(JSON.print(chart_data, "\t"))
		file.close()
	pass

func recieve_chart_file(path):
	if path.split(".")[-1] == "json":
		var file = File.new()
		file.open(path, File.READ)
		chart_data = JSON.parse(file.get_as_text()).result
		preview_data = chart_data.duplicate(true)
		$Control/TextEdit.text = JSON.print(chart_data, "\t")

func recieve_json_parse_error(json_parse:JSONParseResult):
	if json_parse.error != OK:
		$"JSON Parse Error Button".visible = true
	else:
		$"JSON Parse Error Button".visible = false

func recieve_track_notes(track : EditorNoteTrack, notes):
	if track.player_track:
		player_note_array = notes
	else:
		enemy_note_array = notes
	pass

func _on_Import_Chart_Data_Button_pressed():
	$FileDialog.popup()
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	var file = File.new()
	file.open(path, File.READ)
	var data : Dictionary = JSON.parse(file.get_as_text()).result
	var data_str = JSON.print(data, "\t")
	print(data_str)
	$Control/TextEdit.text = data_str
	chart_data = data
#	var data_string = printt()
	pass # Replace with function body.


func _on_LineEdit_text_entered(new_text):
	print("\n",chart_data)
	print("")
	print(preview_data, "\n")
	
	get_keys_from_string(new_text)
	preview_array_setup()
	
	print(chart_data)
	print("")
	print(preview_data, "\n")
	pass # Replace with function body.


func _on_TextEdit_text_changed():
	var thing = JSON.parse($Control/TextEdit.text)
	if thing.error == OK:
		print("GOOD")
		var thing_dict = thing.result
		var yeah = get_nested_value(chart_data, note_array_keys)
		change_nested_key(thing_dict, note_array_keys, yeah)
		chart_data = thing_dict
	else:
		print("JSON PARSE ERROOOROROR")
	get_tree().call_group("JSON Parse Error Recievers", "recieve_json_parse_error", thing)
	pass # Replace with function body.


func _on_Export_Chart_Box_file_selected(path):
	export_chart(path)
	pass # Replace with function body.


func _on_JSON_Parse_Error_Button_pressed():
	$"JSON Parse Error Dialog".popup()
	pass # Replace with function body.


func _on_Export_Chart_pressed():
	$"Export Chart Box".popup()
	pass # Replace with function body.
