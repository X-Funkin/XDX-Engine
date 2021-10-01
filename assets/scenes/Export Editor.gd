extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
#	var data_string = printt()
	pass # Replace with function body.
