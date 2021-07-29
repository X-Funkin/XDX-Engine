extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var story_node_path
export(NodePath) var freeplay_node_path
export(NodePath) var donate_node_path
export(NodePath) var options_node_path
export(NodePath) var scroll_audio
export(NodePath) var confirm_audio
export(NodePath) var cancel_audio
export(NodePath) var animation_thingy
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func refocus(node : Control):
	var focus_pos : Vector2 = node.rect_size/2.0
	var global_pos = node.get_global_transform()*focus_pos
#	var global_pos = node.get_global_transform()*focus_pos
	get_parent().focus_pos = global_pos

func defocus_buttons():
	get_node(story_node_path).focus_mode = Control.FOCUS_NONE
	get_node(story_node_path).focus_mode = Control.FOCUS_ALL
	
	get_node(freeplay_node_path).focus_mode = Control.FOCUS_NONE
	get_node(freeplay_node_path).focus_mode = Control.FOCUS_ALL
	
	get_node(donate_node_path).focus_mode = Control.FOCUS_NONE
	get_node(donate_node_path).focus_mode = Control.FOCUS_ALL
	
	get_node(options_node_path).focus_mode = Control.FOCUS_NONE
	get_node(options_node_path).focus_mode = Control.FOCUS_ALL

func _on_Story_Mode_Button_pressed():
	defocus_buttons()
	get_node(animation_thingy).play("button_pressed")
	get_node(confirm_audio).play()
	pass # Replace with function body.


func _on_Story_Mode_Button_mouse_entered():
	pass # Replace with function body.


func _on_Story_Mode_Button_mouse_exited():
	get_node(story_node_path).focus_mode = Control.FOCUS_NONE
	get_node(story_node_path).focus_mode = Control.FOCUS_ALL


func _on_Story_Mode_Button_focus_entered():
	refocus(get_node(story_node_path))
	get_node(scroll_audio).play()


func _on_Freeplay_Button_focus_entered():
	refocus(get_node(freeplay_node_path))
	var node : AudioStreamPlayer = get_node(scroll_audio)
	node.play()
	pass # Replace with function body.


func _on_Donate_Button_focus_entered():
	refocus(get_node(donate_node_path))
	get_node(scroll_audio).play()
	pass # Replace with function body.


func _on_Options_Button_focus_entered():
	refocus(get_node(options_node_path))
	get_node(scroll_audio).play()
	pass # Replace with function body.
