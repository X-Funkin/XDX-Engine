extends Node2D


export(NodePath) var character
export(String) var enter_animation

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func start():
	$AnimationPlayer.play("fade in")
	$"Opening Text/Opening Text Animations".play("opening text lol")
#	$AudioStreamPlayer.play()

func enter():
	get_node(character).play_animation(enter_animation)
	$"Start Menu/Enter".play("confirm")
	$"Start Menu/AudioStreamPlayer".play()
	$"Start Menu/AnimationPlayer".play("start menu lol")
	$"Start Menu/Enter Timer".start()
	

var ready_to_start = false
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if ready_to_start:
			enter()
		
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
#		start()
#		get_tree().change_scene("res://assets/scenes/Game Menu.tscn")
func _ready():
	$Camera2D.current = true
	start()
	pass
#	$AnimationPlayer.play("fade in")
#	$"Opening Text/AnimationPlayer".play("opening text lol")
#	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	pass


func _on_Enter_Timer_timeout():
	get_tree().call_group("Menu Switchers", "switch_to_main")
	pass # Replace with function body.


func _on_Opening_Text_Animations_animation_finished(anim_name):
	$"Start Menu/logo".play()
	$"Start Menu/gf".play()
	$"Start Menu/Enter".play()
	get_node(character).play_animation("Idle")
	$"Start Menu/AnimationPlayer".play("start menu lol")
	ready_to_start = true
	pass # Replace with function body.
