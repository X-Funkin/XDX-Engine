extends Node2D
class_name Arrow

export(NodePath) var arrow_sprite
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func play_animation(anim):
	var arrow_node : AnimatedSprite = get_node(arrow_sprite)
	arrow_node.stop()
	arrow_node.play(anim)
	arrow_node.frame = 0

func play_press():
	var node : AnimatedSprite = get_node(arrow_sprite)
	if node.animation != "confirm" and node.animation != "confirm_loop":
		play_animation("press")
	pass

func play_confirm():
	print("CONFIRM!!")
	play_animation("confirm")
	pass

func play_confirm_loop():
	print("CONFIRM!! LOOP")
	play_animation("confirm_loop")
	pass

func play_confirm_tap():
	print("CONFIRM TAP")
	play_animation("confirm_tap")

func play_default():
	play_animation("default")
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
