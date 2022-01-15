#extends PopupPanel
extends Panel

export(NodePath) var label_node
export(String, MULTILINE) var text
export(String) var format_text
export(float) var progress
export(int) var current_chunk
export(int) var total_chunks

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func update_text():
	var node = get_node_or_null(label_node)
	if node:
#		var new_text = "%s/%s"%[current_chunk,total_chunks]
		var new_text = "%3.2f"%(progress*100.0)
		node.text = text.format({format_text: new_text})

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recieve_waveform_draw_start():
#	popup()
	visible = true

func recieve_waveform_draw_finish():
#	hide()
	visible = false
	var node = get_node_or_null(label_node)
	if node:
#		var new_text = "%s/%s"%[current_chunk,total_chunks]
#		node.text = text.format({format_text: new_text})+"\nDONE!!!"
		node.text += "\nDONE!!"
#	hide()
#

func recieve_waveform_draw_progress(draw_progress):
	progress = draw_progress
	update_text()
	pass

func recieve_waveform_total_chunks(chunk_count):
	total_chunks = chunk_count
	update_text()

func recieve_waveform_current_chunk(chunk):
	current_chunk = chunk
	update_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
