extends HoldNote
class_name EditorHoldNote


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
#	check_active()
	if active:
		if player_note:
#			print("adjfd")
			check_scorability()
		else:
			check_auto_play()
	if !active:
		if get_parent().song_time < hit_time+hold_time:
			spawn()
			update_scale()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
