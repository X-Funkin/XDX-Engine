extends Viewport
class_name DynamicViewport

export(Vector2) var base_size = Vector2(1920,1080) setget set_base_size
export(Vector2) var resolution_scale = Vector2(1.0,1.0) setget set_resolution_scale

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_base_size(n_size):
	base_size = n_size
	size = base_size*resolution_scale

func set_resolution_scale(n_scale):
	resolution_scale = n_scale
	size = base_size*resolution_scale

# Called when the node enters the scene tree for the first time.
func _ready():
#	self.set_process()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
