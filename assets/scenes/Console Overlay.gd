extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var load_map = {
	"Main": "res://assets/scenes/Menu Screens.tscn",
	"Chart Editor": "res://assets/scenes/Chart Editor.tscn",
	"test": "res://assets/scenes/Mod Chart Test.tscn"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_input()

func get_input():
	var input_text = $Input.text
	cout("> "+input_text)
	parse_input(input_text)
	yield(get_tree(),"idle_frame")
	$Input.text = ""

func parse_input(string):
	if string != "":
		var args = string.split(" ", false, 1)
		match args[0]:
			"load":
				load_scene(args[1])
				pass
			_:
				cout("\"%s\" is not a valid command"%args[0])
		pass

func cout(string):
	$Output.text += "\n"+String(string)
	$Output.scroll_vertical += 10
	pass

func load_scene(scene):
	cout("Loading %s"%scene)
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	if scene in load_map:
		var err = get_tree().change_scene(load_map[scene])
		if err != OK:
			cout('"%s" could not be loaded'%scene)
	else:
		var err = get_tree().change_scene(scene)
		if err != OK:
			cout('"%s" could not be loaded'%scene)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
