tool
extends Control


export(String) var text setget set_text
export(Color) var focused_color = Color(1,1,1,1)
export(Color) var unfocused_color = Color(1,1,1,0.5)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func set_text(n_text):
	text = n_text
	if not is_inside_tree(): yield(self, "ready")
	$"FNF Text".text = n_text
#	rect_size = $"FNF Text".rect_size
#	rect_min_size = $"FNF Text".rect_min_size
#	print(value)
#	text = value

signal button_down
signal button_up
signal pressed
signal toggled(button_pressed)

# Called when the node enters the scene tree for the first time.
func _ready():
#	grab_focus()
	rect_size = $"FNF Text".rect_size
	rect_min_size = $"FNF Text".rect_size
	unfocused()
#	text
	pass # Replace with function body.


func focused():
	modulate = focused_color
	if get_parent().has_method("refocus"):
		get_parent().focus_pos = rect_position.y
		print("okay lets see if this worked ", rect_position.y)
func unfocused():
	modulate = unfocused_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	rect_size = $"FNF Text".rect_size
#	rect_min_size = $"FNF Text".rect_size
#	pass


func _on_FNF_Text_item_rect_changed():
#	rect_size = $"FNF Text".rect_size
#	rect_min_size = $"FNF Text".rect_size
	pass # Replace with function body.


func _on_Button_pressed():
	print("eyayayayyyaa")
	pass # Replace with function body.


func _on_FNF_Button_pressed():
	print(":akjpsdfha")
	pass # Replace with function body.


func _on_FNF_Button_focus_entered():
	focused()
	pass # Replace with function body.


func _on_FNF_Button_focus_exited():
	unfocused()
	pass # Replace with function body.


func _on_FNF_Button_gui_input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("pressed")
		print("yo mama ", text)
	pass # Replace with function body.


func _on_FNF_Text_text_changed():
	update_rect()
#	print("button rect size ", rect_size)
#	print("button rect min size ", rect_min_size)
#	print("fnf text rect size ", $"FNF Text".rect_size)
#	print("fnf text rect min size ", $"FNF Text".rect_min_size)
#	self.rect_size = $"FNF Text".rect_size
#	self.rect_min_size = $"FNF Text".rect_size
#	self.rect_size = Vector2(0,0)
#	print("button rect size now ", rect_size)
#	print("button rect min size now ", rect_min_size)
	pass # Replace with function body.

func update_rect():
#	print("\n\nTHINGYYYC")
#	print("button rect size ", rect_size)
#	print("button rect min size ", rect_min_size)
#	print("fnf text rect size ", $"FNF Text".rect_size)
#	print("fnf text rect min size ", $"FNF Text".rect_min_size)
	self.rect_size = $"FNF Text".rect_size
	self.rect_min_size = $"FNF Text".rect_size
	self.rect_size = Vector2(0,0)
#	print("button rect size now ", rect_size)
#	print("button rect min size now ", rect_min_size)


func _on_FNF_Button_resized():
	update_rect()
	pass # Replace with function body.
