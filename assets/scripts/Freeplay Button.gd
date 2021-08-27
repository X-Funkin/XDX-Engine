tool
extends Control

export(String) var text setget set_text
export(Texture) var freeplay_icon setget set_freeplay_icon
export(Color) var focused_color = Color(1,1,1,1)
export(Color) var unfocused_color = Color(1,1,1,0.5)

var fnf_text : NodePath = @"HBoxContainer/CenterContainer/FNF Text"
var freeplay_texture : NodePath = @"HBoxContainer/Freeplay Icon"

func update_rect():
	$HBoxContainer.rect_size = Vector2(0,0)
	rect_min_size = $HBoxContainer.rect_size
	rect_size = $HBoxContainer.rect_size
#	get_node(fnf_text).anchor_top = 0.25

func set_text(n_text):
	text = n_text
	if not is_inside_tree(): yield(self, "ready")
	get_node(fnf_text).text = n_text
	update_rect()

func set_freeplay_icon(n_icon):
	freeplay_icon = n_icon
	if not is_inside_tree(): yield(self, "ready")
	get_node(freeplay_texture).texture = n_icon
	update_rect()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	update_rect()
#	pass


func _on_Freeplay_Button_focus_entered():
	modulate = focused_color
	pass # Replace with function body.


func _on_Freeplay_Button_focus_exited():
	modulate = unfocused_color
	pass # Replace with function body.
