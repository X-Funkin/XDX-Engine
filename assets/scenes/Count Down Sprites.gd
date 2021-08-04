#tool
extends Node2D

export(Texture) var ready_sprite setget set_ready_sprite
export(Texture) var set_sprite setget set_set_sprite
export(Texture) var go_sprite setget set_go_sprite
var sprite_speed = 2 setget set_sprite_speed
export(AudioStream) var three_sound setget set_three_sound
export(AudioStream) var two_sound
export(AudioStream) var one_sound
export(AudioStream) var go_sound

func set_ready_sprite(n_sprite):
	ready_sprite = n_sprite
	if not is_inside_tree(): yield(self, 'ready')
	get_node("Ready?").texture = ready_sprite

func set_set_sprite(n_sprite):
	set_sprite = n_sprite
	if not is_inside_tree(): yield(self, 'ready')
	get_node("Set").texture = set_sprite

func set_go_sprite(n_sprite):
	go_sprite = n_sprite
	if not is_inside_tree(): yield(self, 'ready')
	get_node("Go!").texture = go_sprite

func set_sprite_speed(n_speed):
	sprite_speed = n_speed
	if not is_inside_tree(): yield(self, 'ready')
	$"Sprite Animations".playback_speed = sprite_speed

func set_three_sound(n_sound):
	three_sound = n_sound
	if not is_inside_tree(): yield(self, 'ready')
	$"3 Sound".stream = three_sound

func set_two_sound(n_sound):
	two_sound = n_sound
	if not is_inside_tree(): yield(self, 'ready')
	$"2 Sound".stream = two_sound

func set_one_sound(n_sound):
	one_sound = n_sound
	if not is_inside_tree(): yield(self, 'ready')
	$"1 Sound".stream = one_sound

func set_go_sound(n_sound):
	go_sound = n_sound
	if not is_inside_tree(): yield(self, 'ready')
	$"Go! Sound".stream = go_sound

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func recieve_count_down(count_down):
	match count_down:
		0:
			$"Sprite Animations".play("Go!")
			$"Go! Sound".play()
		1:
			$"Sprite Animations".play("Set")
			$"1 Sound".play()
		2:
			$"Sprite Animations".play("Ready?")
			$"2 Sound".play()
		3:
			$"Sprite Animations".play("Default")
			$"3 Sound".play()
		
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
