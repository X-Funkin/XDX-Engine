extends Node2D
class_name Note

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var hit_time
export(int, "Left", "Down", "Up", "Right") var note_type
export(float) var hold_time
export(bool) var player_note
export(Dictionary) var custom_data

class NoteSorter:
	static func sort_hit_time(a,b):
		return a.hit_time < b.hit_time
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
