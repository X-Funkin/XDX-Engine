extends Control
class_name DialogueNode

export(NodePath) var target_node
export(int,0) var next_index = 0
export(bool) var dialogue_finished = false
export(NodePath) var text_label
export(NodePath) var animation_node
export(int, "Time", "Speed") var dialogue_write_method
export(float) var dialogue_time = 1.0
export(float) var letter_speed = 10.0
#export()
export(NodePath) var next_dialogue_node
export(int, "Once", "Each Letter") var dialogue_sound_plays = 1
export(AudioStream) var dialogue_start_sound
export(AudioStream) var dialogue_sound = preload("res://assets/sounds/dialogue sound.ogg")
export(AudioStream) var dialogue_finish_sound
export(AudioStream) var dialogue_next_sound = preload("res://assets/sounds/next dialogue sound.ogg")
export(AudioStream) var dialogue_previous_sound


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



signal dialogue_next
signal dialogue_prev
signal dialogue_finished
signal dialogue_ended
signal dialogue_started
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	unfocused()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var T = 0
func _process(delta):
	if !dialogue_finished:
		var textnode :Label = get_node(text_label)
		var current_letter_num = textnode.visible_characters
		if textnode.percent_visible >= 1.0:
			finish_dialogue()
			
			pass
		match dialogue_write_method:
			0:
				
				textnode.percent_visible = clamp(textnode.percent_visible+delta/dialogue_time,0,1)
			1:
				textnode.visible_characters = letter_speed*T
		T += delta
		if current_letter_num != textnode.visible_characters and dialogue_sound_plays == 1:
			play_dialogue_sound()
	#	pass

func get_dialogue_children():
	var child_dialogue_nodes = []
	for node in get_children():
#		if node is DialogueNode: #omggg nooooo you can't have test if node is of is same as this one!!!!!!! cyclical reffereanceeeeaaaahhh!!!! 
		if node.has_method("get_dialogue_children"): #haha has_method() go brrrrrrr
			child_dialogue_nodes.append(node)
			pass
	return child_dialogue_nodes

func play_dialogue_sound():
	$"Dialogue Sound".stop()
	$"Dialogue Sound".play()

func focused():
	get_node(target_node).visible = true
#	visible = true
#	self.self_modulate = Color(1,1,1,1)
	visible = true
	
	dialogue_finished = false
	T = 0.0
	var textnode :Label = get_node(text_label)
	textnode.visible_characters = 0
	textnode.percent_visible = 0
	$"Dialogue Sound".stream = dialogue_sound
	if dialogue_sound_plays == 0:
		play_dialogue_sound()
	var anim_node : AnimationPlayer = get_node_or_null(animation_node)
	if anim_node:
		if anim_node.has_animation("Start Dialogue"):
			anim_node.play("Start Dialogue")
	pass

func unfocused():
	dialogue_finished = false
	get_node(target_node).visible = false
#	visible = false
#	self.self_modulate = Color(1,1,1,0)
#	for node in get_children():
#		node.visible = false
	pass

func finish_dialogue():
	dialogue_finished = true
	var textnode :Label = get_node(text_label)
	textnode.visible_characters = -1
	textnode.percent_visible = 1.0
	$"Dialogue Sound".stop()
	$"Dialogue Finish Sound".play()
	pass

func next_dialogue():
	if get_node_or_null(next_dialogue_node):
		var next_node = get_node(next_dialogue_node)
		next_node.grab_focus()
	else:
		var child_dialogue = get_dialogue_children()
		if child_dialogue.size() > next_index:
			child_dialogue[next_index].grab_focus()
		else:
			emit_signal("dialogue_ended")
	$"Dialogue Next Sound".stream = dialogue_next_sound
	$"Dialogue Next Sound".play()
	emit_signal("dialogue_next")
	pass

func prev_dialogue():
	if get_parent().has_method("get_dialogue_children"):
		get_parent().grab_focus()
	emit_signal("dialogue_prev")
	pass


func _on_Dialogue_Node_focus_entered():
	focused()
	print(name, " HAS FOCUSSSS")
	pass # Replace with function body.


func _on_Dialogue_Node_focus_exited():
	unfocused()
	pass # Replace with function body.


func _on_Dialogue_Node_gui_input(event : InputEvent):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_right"):
		if dialogue_finished:
			next_dialogue()
		else:
			finish_dialogue()
	if event.is_action_pressed("ui_left"):
		prev_dialogue()
		pass
	pass # Replace with function body.
