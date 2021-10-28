extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var moving = false

func recieve_split_note_track():
	var new_track = $"Note Track".duplicate(8)
#	add_child(new_track)
	$"2nd note track boi".add_child(new_track)
#	moving=true
	$"Note Track Anim".play("MOOOOVE OVER")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if moving:
#		$"Note Track".position.x = $"Note Track".position.linear_interpolate(Vector2(300,0))
#	pass


func _on_note_rota_te_timer_timeout():
#	$"Note Track Anim".play("NOTE TRACK ROTA TE")
	$"Note Track Anim".play("SWING IN")
	pass # Replace with function body.


func _on_Note_Track_Anim_animation_finished(anim_name):
	if anim_name == "SWING IN":
		$"Note Track Anim".play("NOTE TRACK ROTA TE")
	pass # Replace with function body.
