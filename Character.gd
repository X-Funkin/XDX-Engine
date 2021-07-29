#tool
extends Node2D
class_name Character

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var character_sprite setget set_character_sprite, get_character_sprite
export(int, "Bottom", "Center", "Top") var sprite_vertical_alignment = 0
export(int, "Left", "Center", "Right") var sprite_horizontal_alignment = 1
export(bool) var custom_alignment = false
export(float, -1.0, 1.0) var custom_vertical_alignment = 0.0
export(float, -1.0, 1.0) var custom_horizontal_alignment = 0.0
export(bool) var player = false
# Called when the node enters the scene tree for the first time.

var yeahready = false #this stops the engine form going "OOO THE CHARACTER SPRITE THE SRPITE OF THE CHARATER OOO I CAN'T IT'S NOT THERE OOOO CRASH GANG CRASH GANG

#Setter/Getters
func set_character_sprite(n_sprite):
	if not is_inside_tree(): yield(self, 'ready')
	character_sprite = n_sprite
	get_node(n_sprite).connect("frame_changed", self, "_on_sprite_frame_change")
	realign_sprite()

func get_character_sprite():
	if yeahready:
		return character_sprite


#Neato Utility funktions
func realign_sprite(): #Realigns the sprite to the set aligment
	var character_node : AnimatedSprite = get_node(character_sprite)
	var sprite_frame = character_node.frames.get_frame(character_node.animation,character_node.frame)
	var center_offset = Vector2()
	if !custom_alignment:
		match sprite_vertical_alignment:
			0:
				center_offset.y = -sprite_frame.get_size().y/2.0
			2:
				center_offset.y = sprite_frame.get_size().y/2.0
		match sprite_horizontal_alignment:
			0:
				center_offset.x = sprite_frame.get_size().x/2.0
			2:
				center_offset.x = -sprite_frame.get_size().x/2.0
	else:
		center_offset.x = custom_horizontal_alignment*sprite_frame.get_size().x/2.0
		center_offset.y = -custom_vertical_alignment*sprite_frame.get_size().y/2.0
	character_node.offset = center_offset
	pass

func _on_sprite_frame_change():
	var character_node : AnimatedSprite = get_node(character_sprite)
#	print(character_node.frames.get_frame(character_node.animation,character_node.frame).get_size())
	realign_sprite()
	pass

#Input and Receiver Functions

func recieve_player_input(event : InputEvent):
	pass

func recieve_player_hit(note, hit_error):
	pass

func recieve_player_miss(note):
	pass

func recieve_hit(note, hit_error):
	pass

func recieve_miss(note):
	pass

func _ready():
	pass
#	yeahready = true
#	set_character_sprite(character_sprite)
#	self.character_sprite = character_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
