extends Node2D

export(NodePath) var player_miss_sound
export(NodePath) var player_death_sound
export(NodePath) var player_death_music
export(NodePath) var player_death_confirm
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func play_miss():
	get_node(player_miss_sound).stop()
	get_node(player_miss_sound).play()

func play_death():
	get_node(player_death_sound).stop()
	get_node(player_death_sound).play()

func recieve_player_death_loop():
	get_node(player_death_music).play()

func recieve_player_death_confirm():
	get_node(player_death_music).stop()
	get_node(player_death_confirm).play()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
