extends Node2D
class_name JudgmentParicles


#export(PackedScene) var particles_scene
var particles_scene = preload("res://assets/scenes/Judgment Particles Instance.tscn")
export(Texture) var max_judgment
export(Texture) var sick_judgment
export(Texture) var good_judgment
export(Texture) var bad_judgment

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func recieve_player_judgment(judgement):
	var inst = particles_scene.instance()
	var tex = bad_judgment
	match judgement:
		2:
			tex = bad_judgment
		3:
			tex = good_judgment
		4:
			tex = sick_judgment
		5:
			tex = max_judgment
	inst.texture = tex
	add_child(inst)
	inst.emitting = true

func recieve_enemy_input(event : InputEvent):
	if event.is_pressed():
		var inst = particles_scene.instance()
		var tex = max_judgment
		inst.texture = tex
		add_child(inst)
		inst.emitting = true

#func recieve_player_hit(note : Note, hit_error):
#	var inst = particles_scene.instance()
#	var tex = bad_judgment
#	if abs(hit_error) < 73.5:
#		tex = good_judgment
#	if abs(hit_error) < 40.5:
#		tex = sick_judgment
#	if abs(hit_error) < 16.5:
#		tex = max_judgment
#	inst.texture = tex
#	add_child(inst)
#	inst.emitting = true
	
#	$Particles2D.emitting = true
#	$Particles2D.emitting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#	$Particles2D.emitting = false
#	pass
