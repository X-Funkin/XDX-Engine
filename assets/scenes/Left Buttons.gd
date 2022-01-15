extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recieve_bpm(bpm):
	$"Control/BPM Edit".text = str(bpm)

func recieve_snapping_offset(offset):
	$"Control2/Snapping Offset Edit".text = str(offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BPM_Edit_text_entered(new_text):
	$"Control/BPM Edit".release_focus()
	pass # Replace with function body.


func _on_Snapping_Offset_Edit_text_entered(new_text):
	$"Control2/Snapping Offset Edit".release_focus()
	pass # Replace with function body.


func _on_Playback_Speed_Edit_text_entered(new_text):
	$"Control3/Playback Speed Edit".release_focus()
	pass # Replace with function body.
