extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mesh_yeah : ArrayMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$"Waveform Visualizer".draw_waveform(true)
		$Sprite.texture = $"Waveform Visualizer".wave_texture
#		$MeshInstance2D.mesh = mesh_yeah
	if event is InputEventMouseMotion:
		match event.button_mask:
			BUTTON_LEFT:
				$"time start".position.y = get_global_mouse_position().y
				update_the_thing()
			BUTTON_RIGHT:
				$"time end".position.y = get_global_mouse_position().y
				update_the_thing()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func update_the_thing():
	var start = $"time start".global_position.y
	var end = $"time end".global_position.y
	var mat = $"Waveform Visualizer".global_transform
	var wav_start = mat.affine_inverse()*Vector2(0,start)
	var wav_end = mat.affine_inverse()*Vector2(0,end)
	$"Waveform Visualizer".start_time = wav_start.y
	$"Waveform Visualizer".end_time = wav_end.y

func _process(delta):
	$DebugTexture.rotation_degrees += delta*100
#	pass
