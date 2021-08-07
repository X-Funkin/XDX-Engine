tool
extends Camera2D
export(bool) var following_point
export(float) var following_speed
export(NodePath) var follow_point

#func set_scale(value):
#	print("scale ", value)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if following_point:
		position = position.linear_interpolate(get_node(follow_point).position, delta*following_speed)
		zoom = zoom.linear_interpolate(get_node(follow_point).scale, delta*following_speed)
	scale = zoom
#	pass
