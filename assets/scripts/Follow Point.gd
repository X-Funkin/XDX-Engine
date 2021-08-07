tool
extends Position2D

export(NodePath) var position_one setget set_position_one
export(Vector2) var offset_one setget set_offset_one
export(float) var zoom_one setget set_zoom_one

export(NodePath) var position_two setget set_position_two
export(Vector2) var offset_two setget set_offset_two
export(float) var zoom_two setget set_zoom_two

export(float) var mix setget set_mix

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_mix(n_mix):
	mix = n_mix
	if not is_inside_tree(): yield(self, 'ready')
	position = lerp(get_node(position_one).position+offset_one, get_node(position_two).position+offset_two,mix)
	scale = Vector2(lerp(zoom_one, zoom_two,mix),lerp(zoom_one, zoom_two,mix))

func set_position_one(n_pos):
	position_one = n_pos
	self.mix = mix

func set_offset_one(n_offset):
	offset_one = n_offset
	self.mix = mix

func set_zoom_one(n_zoom):
	zoom_one = n_zoom
	self.mix = mix

func set_position_two(n_pos):
	position_two = n_pos
	self.mix = mix

func set_offset_two(n_offset):
	offset_two = n_offset
	self.mix = mix

func set_zoom_two(n_zoom):
	zoom_two = n_zoom
	self.mix = mix


func goto_position(pos):
	match pos:
		0:
			self.mix = 0
		1:
			self.mix = 1

func recieve_beat(beat_n):
#	goto_position(beat_n%2)
	if beat_n > 10:
		match (beat_n/8)%2:
			0:
				goto_position(1)
			1:
				goto_position(0)
			
		
		
#		_:
#			goto_position(0)
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	goto_position(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.mix = mix
#	position = lerp(get_node(position_one).position+offset_one, get_node(position_two).position+offset_two,mix)
#	scale = Vector2(lerp(zoom_one, zoom_two,mix),lerp(zoom_one, zoom_two,mix))
#	print("alksdjfk")
#	if not is_inside_tree(): yield(self, 'ready')
#	self.mix = mix
#	set_mix(mix)
	
#	if not is_inside_tree(): yield(self, 'ready')
#	position = lerp(get_node(position_one).position+offset_one, get_node(position_two).position+offset_two,mix)
#	scale = Vector2(lerp(zoom_one, zoom_two,mix),lerp(zoom_one, zoom_two,mix))
	
#	position = lerp(get_node(position_one).position+offset_one, get_node(position_two).position+offset_two,mix)
#	scale = Vector2(lerp(zoom_one, zoom_two,mix),lerp(zoom_one, zoom_two,mix))
#	pass
