extends Control

export(NodePath) var framerate_label
export(NodePath) var memory_usage_label
export(bool) var show_framerate setget set_show_framerate
export(bool) var show_memory_usage setget set_show_memory_usage

func set_show_framerate(n_show):
	show_framerate = n_show
	if not is_inside_tree(): yield(self, "ready")
	get_node(framerate_label).visible = show_framerate
	if !show_framerate and !show_memory_usage:
		visible = false
#		visible
	elif show_framerate:
		visible = true

func set_show_memory_usage(n_show):
	show_memory_usage = n_show
	if not is_inside_tree(): yield(self, "ready")
	get_node(memory_usage_label).visible = show_memory_usage
	if !show_framerate and !show_memory_usage:
		visible = false
	elif show_memory_usage:
		visible = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_fps_label():
	var framerate = Performance.get_monitor(Performance.TIME_FPS)
	var fps_node = get_node(framerate_label)
	fps_node.text = "%s FPS"%framerate

func update_mem_label():
	var memory_usage = Performance.get_monitor(Performance.MEMORY_STATIC)
	var mem_node = get_node(memory_usage_label)
	mem_node.text = "%4.1f MB"%(float(memory_usage)/1048576.0)

func update_labels():
	update_fps_label()
	update_mem_label()
	pass

func _physics_process(delta):
	update_labels()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
