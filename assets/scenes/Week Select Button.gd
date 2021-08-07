extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var week_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("focus_entered", self, "_on_focus_entered")
	pass # Replace with function body.


func _on_focus_entered():
	get_tree().call_group("Week Data Recievers", "recieve_week_data", week_data)
	get_parent().scroll_target = rect_position.y
	print("eyahahah")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
