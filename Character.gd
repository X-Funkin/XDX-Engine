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
export(bool) var sprite_realignment = true
var dead = false

# Called when the node enters the scene tree for the first time.

var yeahready = false #this stops the engine form going "OOO THE CHARACTER SPRITE THE SRPITE OF THE CHARATER OOO I CAN'T IT'S NOT THERE OOOO CRASH GANG CRASH GANG

#Setter/Getters
func set_character_sprite(n_sprite):
	if not is_inside_tree(): yield(self, 'ready')
	character_sprite = n_sprite
	get_node(n_sprite).connect("frame_changed", self, "_on_sprite_frame_change")
	get_node(n_sprite).connect("animation_finished", self, "_on_sprite_animation_finished")
	realign_sprite()

func get_character_sprite():
	if yeahready:
		return character_sprite


#Neato Utility funktions
func realign_sprite(): #Realigns the sprite to the set aligment
	if sprite_realignment:
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

func _on_sprite_animation_finished():
	var character_node : AnimatedSprite = get_node(character_sprite)
	var anim = character_node.animation
	if player:
		if anim == "Dies":
			character_node.play("Death Loop")
			get_tree().call_group("Player Death Recievers", "recieve_player_death_loop")
		if anim == "Death Comfirm":
			print("yeah death confirm boiiis")
			get_tree().paused = false
			get_tree().reload_current_scene()
	pass

#func _on_sprite_animation_change():
#	pass

func recieve_beat(beat_n):
#	print("BF GOT THAT BEAT THOOO ", beat_n)
	var character_node : AnimatedSprite = get_node(character_sprite)
	var anim = character_node.animation
#	print("ANIM ", anim)
	if anim == "Default" or anim == "Bop":
#		print("IT PASSES THE TEST")
		character_node.stop()
		character_node.frame = 0
		character_node.play("Bop")
	realign_sprite()

func play_input_animation(anim, pressed):
	if player or true:
		var character_node : AnimatedSprite = get_node(character_sprite)
		if pressed:
			if character_node.animation != anim:
				character_node.stop()
				character_node.play(anim)
		elif character_node.animation == anim:
			character_node.stop()
			character_node.play("Default")
		realign_sprite()
#Input and Receiver Functions

func recieve_player_input(event : InputEvent):
	pass

func recieve_player_left_input(event : InputEvent):
	if player:
		play_input_animation("Left", event.is_pressed())

func recieve_player_down_input(event : InputEvent):
	if player:
		play_input_animation("Down", event.is_pressed())

func recieve_player_up_input(event : InputEvent):
	if player:
		play_input_animation("Up", event.is_pressed())

func recieve_player_right_input(event : InputEvent):
	if player:
		play_input_animation("Right", event.is_pressed())

func recieve_player_hit(note, hit_error):
	pass

func recieve_player_miss(note_type):
	if player:
		match note_type:
			0:
				play_input_animation("Left Miss", true)
			1:
				play_input_animation("Down Miss", true)
			2:
				play_input_animation("Up Miss", true)
			3:
				play_input_animation("Right Miss", true)
			
	pass

#func recieve_enemy_hit(note, hit_error):
#	match note.note_type:
#		0:
#

func recieve_enemy_input(event : InputEvent):
	pass

func recieve_enemy_left_input(event : InputEvent):
	if !player:
		play_input_animation("Left", event.is_pressed())

func recieve_enemy_down_input(event : InputEvent):
	if !player:
		play_input_animation("Down", event.is_pressed())

func recieve_enemy_up_input(event : InputEvent):
	if !player:
		play_input_animation("Up", event.is_pressed())

func recieve_enemy_right_input(event : InputEvent):
	if !player:
		play_input_animation("Right", event.is_pressed())

func recieve_enemy_hit(note, hit_error):
	pass

func recieve_enemy_miss(note):
	pass


func recieve_hit(note, hit_error):
	pass

func recieve_miss(note):
	pass

func recieve_player_death():
	if player:
		dead = true
		var character_node : AnimatedSprite = get_node(character_sprite)
		character_node.stop()
		sprite_realignment = false
		pause_mode = PAUSE_MODE_PROCESS
		character_node.play("Dies")
#		z_index = 4000

func _input(event):
	if event.is_action_pressed("ui_accept") and dead:
		var character_node : AnimatedSprite = get_node(character_sprite)
		character_node.stop()
		character_node.play("Death Comfirm")
		get_tree().call_group("Player Death Recievers", "recieve_player_death_confirm")

func _ready():
	pass
#	yeahready = true
#	set_character_sprite(character_sprite)
#	self.character_sprite = character_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
