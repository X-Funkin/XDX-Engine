extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int, "Easy", "Normal", "Hard") var difficulty
export(float) var scroll_speed = 4.0

# Called when the node enters the scene tree for the first time.

func _input(event):
	if event.is_action_pressed("ui_left"):
		difficulty = posmod(difficulty-1,3)
	if event.is_action_pressed("ui_right"):
		difficulty = posmod(difficulty+1,3)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(difficulty)
#	print(difficulty%3)
#	posmod(difficulty,3)
	var pos = get_child(difficulty%3).rect_position.x
	rect_position.x = lerp(rect_position.x, -pos+20.181, delta*scroll_speed)
#	pass
