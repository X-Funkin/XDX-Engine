extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func start():
	$AnimationPlayer.play("fade in")
	$"Opening Text/AnimationPlayer".play("opening text lol")
	$AudioStreamPlayer.play()
func _input(event):
	if event.is_action_pressed("ui_accept"):
		start()
func _ready():
	pass
#	$AnimationPlayer.play("fade in")
#	$"Opening Text/AnimationPlayer".play("opening text lol")
#	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	$"Start Menu/AnimationPlayer".play("start menu lol")
	$"Start Menu/logo".play()
	$"Start Menu/gf".play()
	$"Start Menu/Enter".play()
