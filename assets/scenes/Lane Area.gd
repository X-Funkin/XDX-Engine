extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"GUI Input Area".connect("mouse_entered", self, "mouse_entered")
	$"GUI Input Area".connect("mouse_exited", self, "mouse_exited")
	$"GUI Input Area".connect("input_event", self, "_on_GUI_Input_Area_input_event")
	pass # Replace with function body.

func move_yeah():
	$noteyah.global_position.y = get_global_mouse_position().y
	pass

func mouse_move():
	move_yeah()

func mouse_entered():
	$noteyah.visible = true
	move_yeah()
	pass

func mouse_exited():
	$noteyah.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GUI_Input_Area_mouse_entered():
	mouse_entered()
	pass # Replace with function body.


func _on_GUI_Input_Area_mouse_exited():
	mouse_exited()
	pass # Replace with function body.


func _on_GUI_Input_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		move_yeah()
	pass # Replace with function body.
