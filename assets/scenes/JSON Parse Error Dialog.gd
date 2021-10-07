extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var no_error_text
export(String, MULTILINE) var error_text
export(String) var error_string
export(int) var error_line

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_error_text():
	$"Error Text".text = error_text.format({"error_line":error_line, "error_string":error_string})


func update_no_error_text():
	$"Error Text".text = no_error_text

func recieve_json_parse_error(json_parse : JSONParseResult):
	if json_parse.error != OK:
		error_string = json_parse.error_string
		error_line = json_parse.error_line
		update_error_text()
	else:
		update_no_error_text()
#	set_error_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
