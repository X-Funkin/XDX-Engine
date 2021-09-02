extends Control

export(NodePath) var first_dialogue
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal dialogue_ended
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(first_dialogue).grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BF_DIP_IT_ALL_IN_MASHED_POTATOES_dialogue_ended():
	emit_signal("dialogue_ended")
	pass # Replace with function body.
