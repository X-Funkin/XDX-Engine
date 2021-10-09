extends Control

export(Color) var grid_line_color setget set_grid_line_color
export(Color) var sub_grid_line_color setget set_sub_grid_line_color

export(float) var grid_line_width = 4.0 setget set_grid_line_width
export(float) var sub_grid_line_width = 2.0 setget set_sub_grid_line_width

export(NodePath) var note_editor_node
export(float) var bpm = 120.0
export(float) var snapping_offset = 0.0
export(float) var song_time = 0.0
export(float) var zoom = 1.0
export(float) var start_time = 0.0
export(float) var end_time = 1000.0


func set_grid_line_color(n_color):
	grid_line_color = n_color
	update()

func set_sub_grid_line_color(n_color):
	sub_grid_line_color = n_color
	update()

func set_grid_line_width(n_width):
	grid_line_width = n_width
	update()

func set_sub_grid_line_width(n_width):
	sub_grid_line_width = n_width
	update()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func update_times():
	var yeah : NoteEditor = get_node(note_editor_node)
	var start_y = $"Grid Start".rect_global_position.y
	var end_y = $"Grid End".rect_global_position.y
	start_time = yeah.song_time_transform(start_y)
	end_time = yeah.song_time_transform(end_y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recieve_song_time(time):
	song_time = time
	update_times()
	update()

func recieve_zoom(zoom):
	self.zoom = zoom
	update_times()
	update()

func recieve_bpm(n_bpm):
	bpm=n_bpm
	update()

func recieve_snapping_offset(offset):
	snapping_offset = offset
	update()

func _draw():
	var snap_length = 60.0/(bpm*4.0*max(1.0,floor(zoom)))
	var time_diff = end_time-start_time
	var line_count = int(ceil(time_diff/(1000.0*snap_length)))
	var line_start_time = stepify(start_time-snapping_offset, snap_length*1000.0)+snapping_offset
	var yeah : NoteEditor = get_node(note_editor_node)
	for line in line_count:
		var song_y = line_start_time+line*snap_length*1000.0
		var global_y = yeah.inv_song_time_transform(song_y)
		var local_y = (get_global_transform().affine_inverse()*Vector2(0,global_y)).y
		draw_line(Vector2(-2000,local_y),Vector2(2000,local_y),sub_grid_line_color,sub_grid_line_width)
	var beat_snap_length = 60.0/(bpm*4.0)
	var major_line_count = int(ceil(time_diff/(1000.0*beat_snap_length)))
	var major_line_start = stepify(start_time-snapping_offset,beat_snap_length*1000.0)+snapping_offset
	for major_line in major_line_count:
		var song_y = major_line_start+major_line*beat_snap_length*1000.0
		var global_y = yeah.inv_song_time_transform(song_y)
		var local_y = (get_global_transform().affine_inverse()*Vector2(0,global_y)).y
		draw_line(Vector2(-2000,local_y),Vector2(2000,local_y),grid_line_color,grid_line_width)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
