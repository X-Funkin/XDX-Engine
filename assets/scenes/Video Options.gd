extends Control


var video_settings = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	video_settings = GameData.data.video_settings
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_accept"):
		GameData.load_video_settings()
		$"Revert Timer".start()
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("Options Menu Switchers", "switch_to_main_options")
		GameData.save_game_data()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Revert_Timer_timeout():
	print("REVERT TIMEOUT")
	GameData.data.video_settings = video_settings
	GameData.load_video_settings()
	pass # Replace with function body.
