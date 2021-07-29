extends GameWeek
class_name WeekSong

export(String) var song_name
export(String, FILE) var chart_file
export(NodePath) var player_track
export(NodePath) var enemy_track

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(player_track).chart_file = chart_file
	get_node(enemy_track).chart_file = chart_file
	get_node(player_track).load_chart()
	get_node(enemy_track).load_chart()
	$Instrumentals.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
