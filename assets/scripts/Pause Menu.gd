extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var surface_menu = true
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
#	$"VBoxContainer/Resume/Resume Button".grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and surface_menu:
		print("pause ui cancel")
		modulate.a = 0.0
		$"Unpause Timer".start()
#		resume()

func exit():
#	get_tree().quit()
	get_tree().paused = false
	get_tree().change_scene("res://assets/scenes/Menu Screens.tscn")

func resume():
	print("resuming")
	get_tree().paused = false
	get_parent().queue_free()

func restart_song():
	get_tree().paused = false
	get_tree().reload_current_scene()
	get_parent().queue_free()

func switch_to_main():
	$"Options Menu Node".visible = false
	$"Button Scroller".visible = true
	for node in $"Options Menu Node".get_children():
		node.queue_free()
	surface_menu = true
	$"Button Scroller".focus_first()

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


func _on_Options_Button_pressed():
	$"Button Scroller".visible = false
	$"Options Menu Node".visible = true
	surface_menu = false
	var options_node = load("res://assets/scenes/Options Menu.tscn").instance()
	$"Options Menu Node".add_child(options_node)
	pass # Replace with function body.
