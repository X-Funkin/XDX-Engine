extends Node2D

var combo_particles = preload("res://assets/scenes/Combo Particles Instance.tscn")
export(Texture) var number_0
export(Texture) var number_1
export(Texture) var number_2
export(Texture) var number_3
export(Texture) var number_4
export(Texture) var number_5
export(Texture) var number_6
export(Texture) var number_7
export(Texture) var number_8
export(Texture) var number_9

export(float) var texture_width = 80
var texture_width_array = [0,0,0,0,0,0,0,0,0,0]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func spawn_number(num, pos):
	var combo_inst = combo_particles.instance()
	var tex = number_0
	match num:
		"1":
			tex = number_1
		"2":
			tex = number_2
		"3":
			tex = number_3
		"4":
			tex = number_4
		"5":
			tex = number_5
		"6":
			tex = number_6
		"7":
			tex = number_7
		"8":
			tex = number_8
		"9":
			tex = number_9
	combo_inst.texture = tex
	add_child(combo_inst)
	combo_inst.position.x = pos
	combo_inst.emitting = true

func recieve_player_combo(combo : int):
	var combo_str = str(combo)
	var length = combo_str.length()
	var thingy = 0
	for letter in combo_str:
		spawn_number(letter,range_lerp(thingy,0,length,-texture_width*length/2.0,texture_width*length/2.0))
		thingy += 1
	

func update_width_array():
	texture_width_array[0] = number_0.get_width()
	texture_width_array[1] = number_1.get_width()
	texture_width_array[2] = number_2.get_width()
	texture_width_array[3] = number_3.get_width()
	texture_width_array[4] = number_4.get_width()
	texture_width_array[5] = number_5.get_width()
	texture_width_array[6] = number_6.get_width()
	texture_width_array[7] = number_7.get_width()
	texture_width_array[8] = number_8.get_width()
	texture_width_array[9] = number_9.get_width()
# Called when the node enters the scene tree for the first time.
func _ready():
	update_width_array()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
