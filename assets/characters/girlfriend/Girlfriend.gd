extends Character
class_name Girlfriend, "res://assets/characters/girlfriend/Girlfriend Icon.png"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func recieve_beat(beat_n):
	if (beat_n+bop_beat_offset)%bop_on_beat == 0:
		match ((beat_n+bop_beat_offset)/bop_on_beat)%2:
			0:
				var character_node : AnimatedSprite = get_node(character_sprite)
				var anim = character_node.animation
				if anim == "Default" or anim == "Bop Left" or anim == "Bop Right":
					character_node.stop()
					character_node.frame = 0
					character_node.play("Bop Left")
			1:
				var character_node : AnimatedSprite = get_node(character_sprite)
				var anim = character_node.animation
				if anim == "Default" or anim == "Bop Left" or anim == "Bop Right":
					character_node.stop()
					character_node.frame = 0
					character_node.play("Bop Right")
		realign_sprite()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
