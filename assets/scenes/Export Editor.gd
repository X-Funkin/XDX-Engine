extends Control

var chart_data : Dictionary
var preview_data : Dictionary
var note_array_keys = []
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

func preview_array_setup():
	if !note_array_keys.empty():
		preview_data = chart_data.duplicate(true)
		var sub_thing = preview_data
		var final_key
		for key in note_array_keys:
			final_key = key
			if sub_thing.has(key):
				if sub_thing[key] is Dictionary:# or sub_thing[key] is Array:
					sub_thing = sub_thing[key]
				else:
					break
			else:
				break
		sub_thing[final_key] = ["NOTES WILL GO HERE"]
		$Control/TextEdit.text = JSON.print(preview_data, "\t")
	else:
		preview_data = chart_data.duplicate(true)
		$Control/TextEdit.text = JSON.print(preview_data, "\t")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func recieve_chart_file(path):
	var file = File.new()
	file.open(path, File.READ)
	chart_data = JSON.parse(file.get_as_text()).result
	preview_data = chart_data.duplicate(true)
	$Control/TextEdit.text = JSON.print(chart_data, "\t")

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
		chart_data = thing.result
	else:
		print("JSON PARSE ERROOOROROR")
	pass # Replace with function body.


func _on_Export_Chart_Box_file_selected(path):
	
	pass # Replace with function body.
