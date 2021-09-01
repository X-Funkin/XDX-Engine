extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var fade_in = 0.0 setget set_fade_in, get_fade_in
export(int, "First", "Second", "Third") var display_colors setget set_display_colors, get_display_colors

export(Color) var base_color = Color("fce872")
export(Color) var line_color = Color("db7426")

export(Color) var second_base_color = Color("9271fd")
export(Color) var second_line_color = Color("2545dc")

export(Color) var third_base_color = Color("fd719b")
export(Color) var third_line_color = Color("dc27a7")
export(NodePath) var yeah
export(NodePath) var fade
var focus_pos : Vector2 setget set_focus_pos, get_focus_pos

var target_string : String = "switch_to_story"

func set_fade_in(n_fade):
	if yeahready:
		fade_in = n_fade
		get_node(fade).material.set_shader_param("Fade",fade_in)

func get_fade_in():
	return fade_in

func set_focus_pos(n_pos):
	focus_pos = n_pos
	$Position2D.position = n_pos/3.0
	

func get_focus_pos():
	return focus_pos

var yeahready = false
func set_display_colors(n_int):
	if yeahready:
		match n_int:
			0:
				get_node(yeah).material.set_shader_param("Base_Color",base_color)
				get_node(yeah).material.set_shader_param("Line_Color",line_color)
			1:
				get_node(yeah).material.set_shader_param("Base_Color",second_base_color)
				get_node(yeah).material.set_shader_param("Line_Color",second_line_color)
			2:
				get_node(yeah).material.set_shader_param("Base_Color",third_base_color)
				get_node(yeah).material.set_shader_param("Line_Color",third_line_color)


func get_display_colors():
	return display_colors


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("Menu Switchers", "switch_to_start")

func _ready():
	yeahready = true
	set_display_colors(display_colors)
	$AnimationPlayer.play("start")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
export(float) var follow_speed = 1.0
func _process(delta):
	get_node(yeah).position = get_node(yeah).position.linear_interpolate(-focus_pos/5.0, delta*follow_speed)
#	pass


#func _on_Story_Mode_Button_focus_entered():
#	print("eyahdfdsfasfdsafdsafdsaf")
#	$"Control/CenterContainer/VBoxContainer/HBoxContainer/Story Mode Button/CenterContainer/Control/AnimatedSprite".play("funkin")
#	pass
#	$"Control/CenterContainer/VBoxContainer/HBoxContainer/Story Mode Button/AnimatedSprite".play("funkin")




func _on_Freeplay_Button_focus_entered():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "button_pressed":
		$Timer.start(1.0)
	pass # Replace with function body.


func _on_Timer_timeout():
	print("ITME OUT")
#	get_tree().change_scene("res://assets/weeks/tutorial/Week Screen.tscn")
	get_tree().call_group("Menu Switchers", target_string)
#	get_tree().change_scene("res://assets/weeks/tutorial/Tutorial.tscn")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "button_pressed":
		$Timer.start(1.0)
	pass # Replace with function body.


func _on_Options_Button_pressed():
	target_string = "switch_to_options"
	pass # Replace with function body.


func _on_Story_Mode_Button_pressed():
	target_string = "switch_to_story"
	pass # Replace with function body.


func _on_Freeplay_Button_pressed():
	target_string = "switch_to_freeplay"
	pass # Replace with function body.
