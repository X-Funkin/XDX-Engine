tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String, MULTILINE) var text setget set_text, get_text
export(int, "Left", "Center", "Right") var alignment setget set_alignment, get_alignment
export(int) var visible_lines setget set_visible_lines, get_visible_lines
export(NodePath) var textvbox
func set_visible_lines(n_lines):
	visible_lines = n_lines
	
	if not is_inside_tree(): yield(self, 'ready')
	var count = 0
	for node in get_node(textvbox).get_children():
		if count < visible_lines or visible_lines == -1:
			node.modulate.a = 1.0
			count += 1
			continue
		if count >= visible_lines:
			node.modulate.a = 0.0
			count += 1
			continue
			

func get_visible_lines():
	return visible_lines
#export(String, MULTILINE) onready var text setget set_text, get_text

func set_alignment(n_alignment):
	alignment = n_alignment
	if not is_inside_tree(): yield(self, 'ready')
	update_alignment()

func update_alignment():
	for node in get_node(textvbox).get_children():
		node.alignment = alignment


func get_alignment():
	return alignment

func set_text(n_text):
	text = n_text
	if not is_inside_tree(): yield(self, 'ready')
#	if yeahready:
	generate_text()


func get_text():
	return text

func generate_text():
	for node in get_node(textvbox).get_children():
		node.queue_free()
	var text_lines = text.split("\n")
	for string in text_lines:
		var hbox = HBoxContainer.new()
		hbox.alignment = alignment
#		var hbox_inst = hbox.instance()
		for character in string:
			if character == " ":
				var letter = load("res://assets/images/alphabet/Space.png")
				var texrec = TextureRect.new()
				texrec.texture = letter
#				var tex_inst = texrec.instance()
				hbox.add_child(texrec)
				continue
			character = character.to_upper()
			var letter = load("res://assets/images/alphabet/%s bold0000.png"%character)
			var texrec = TextureRect.new()
			texrec.texture = letter
#			var tex_inst = texrec.instance()
			hbox.add_child(texrec)
		if string != "":
			get_node(textvbox).add_child(hbox)
			get_node(textvbox).rect_size = Vector2(0,0)
		get_node(textvbox).rect_size = Vector2(0,0)
	get_node(textvbox).rect_size = Vector2(0,0)
	update_rect()
var yeahready = false

func update_rect():
#	rect_position = $Control/CenterContainer/VBoxContainer.rect_position/2.0
	rect_min_size.y = get_node(textvbox).rect_size.y/2.0
	rect_min_size.x = get_node(textvbox).rect_size.x
	rect_size = rect_min_size
	
# Called when the node enters the scene tree for the first time.
func _ready():
	yeahready = true
	set_alignment(alignment)
	set_text(text)
	set_visible_lines(visible_lines)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$VBoxContainer.rect_size = Vector2(0,0)
	update_rect()
#	pass
