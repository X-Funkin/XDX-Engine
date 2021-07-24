extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	
	var data_array = get_parent().get_parent().sprite_sheet_data
	for data in data_array:
		if "name" in data:
			draw_line(Vector2(data["x"]+data["width"]/2.0, data["y"]),Vector2(data["x"]+data["width"]/2.0, data["y"]+data["height"]), Color(1.0,1.0,1.0), data["width"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
