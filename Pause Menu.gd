extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/Resume/Resume Button".grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("pause ui cancel")
		modulate.a = 0.0
		$"Unpause Timer".start()
#		resume()

func exit():
	get_tree().quit()

func resume():
	print("resuming")
	get_tree().paused = false
	get_parent().queue_free()

func restart_song():
	get_tree().paused = false
	get_tree().reload_current_scene()
	get_parent().queue_free()


func _on_Exit_Button_pressed():
	print("Exit Button")
	exit()
	pass # Replace with function body.


func _on_Restart_Song_Button_pressed():
	print("Restart Song Button")
	restart_song()
	
	pass # Replace with function body.


func _on_Resume_Button_pressed():
	print("Resume Button")
	modulate.a = 0.0
	$"Unpause Timer".start()
#	resume()
	pass # Replace with function body.


func _on_Unpause_Timer_timeout():
	resume()
	pass # Replace with function body.
