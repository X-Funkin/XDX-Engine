extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func change_volume(n_volume):
	var count = 0
	for node in $ColorRect/Control/Control.get_children():
		count += 1
		if count > n_volume/10.0:
			node.modulate = Color(1,1,1,0.5)
		else:
			node.modulate = Color(1,1,1,1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(n_volume/100.0))
	$Blip.stop()
	$Blip.play()
	$Timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	get_parent().queue_free()
	pass # Replace with function body.
