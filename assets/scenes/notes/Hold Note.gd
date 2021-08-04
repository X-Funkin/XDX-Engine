#tool
extends Note
class_name HoldNote

export(bool) var holding = false setget set_holding
export(bool) var playing = false setget set_playing
export(bool) var scored = false
export(float) var played_amount = 0.0 setget set_played_amount
export(NodePath) var hold_note_start
export(NodePath) var hold_note_body
export(NodePath) var hold_note_end
export(float) var healing_rate = 20.0
export(float) var damaging_rate = 30.0


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#func set_scale(value): # Keeps the hold good for different scroll speeds
#	print("SCALE CHANGE", self.name)
#	scale = value
#	if not is_inside_tree(): yield(self, 'ready')
#	var hold_sprite = get_node(hold_note_body)
#	var hold_end_sprite = get_node(hold_note_end)
##	var height = hold_sprite.texture.get_height()
#	hold_sprite.scale.y = 1.0/scale.y
##	hold_sprite.scale.y = hold_scale
#	hold_end_sprite.scale.y = 1.0/hold_sprite.scale.y
#	pass


func set_hold_time(n_time):
	hold_time = n_time
	if not is_inside_tree(): yield(self, 'ready')
	var hold_sprite = get_node(hold_note_body)
	var hold_end_sprite = get_node(hold_note_end)
	var height = hold_sprite.texture.get_height()
	var hold_scale = n_time/float(height)
	hold_sprite.scale.y = hold_scale
	hold_end_sprite.scale.y = 1.0/hold_sprite.scale.y

func set_holding(n_holding):
	holding = n_holding
	get_parent().holding_note = n_holding
	if holding:
		get_parent().held_note = self
	else:
		get_parent().held_note = null
	pass

func set_playing(n_playing):
	playing = n_playing

func set_played_amount(n_amount):
#	print(n_amount)
	played_amount = n_amount
	if not is_inside_tree(): yield(self, 'ready')
	if holding and active:
		var hold_sprite = get_node(hold_note_body)
		hold_sprite.material.set_shader_param("Played_Amount", played_amount)
		var pos = hold_sprite.texture.get_height()*hold_sprite.scale.y*played_amount
		get_node(hold_note_start).position.y = pos

func check_scorability():
#	scale.y
	var song_time = get_parent().song_time
	var timing_window = get_parent().timing_window
	if !scorable:
		if abs(hit_time-song_time) < timing_window and !scored:
			scorable = true
			add_to_group(scorable_group)
	else:
		if abs(hit_time-song_time) > timing_window:
			scorable = false
			remove_from_group(scorable_group)
		if song_time > hit_time+timing_window and !holding:
			get_tree().call_group("Player Miss Recievers", "recieve_player_miss", note_type)
			self.holding = true
	if song_time > hit_time+hold_time+timing_window:
		despawn()

func check_auto_play():
	var song_time = get_parent().song_time
	if song_time > hit_time and !holding:
		get_tree().call_group("Enemy Hit Recievers", "recieve_enemy_hit", self, 0.0)
		self.holding = true
		self.playing = true
		


func check_active():
	var song_time = get_parent().song_time
	var timing_window = get_parent().timing_window
	if !active:
		if hit_time-hold_time < song_time-timing_window:
			spawn()
	else:
		if hit_time+hold_time > song_time+timing_window:
			despawn()

func update_scale():
	if not is_inside_tree(): yield(self, 'ready')
	var hold_node = get_node(hold_note_body)
	hold_node.scale.y = (hold_time/float(hold_node.texture.get_height()))/scale.y
	get_node(hold_note_end).scale.y = 1.0/hold_node.scale.y
	self.played_amount = played_amount

func check_holding():
	if holding and playing:
		var song_time = get_parent().song_time
		var played = clamp(range_lerp(song_time, hit_time, hit_time+hold_time, 0.0, 1.0), 0.0, 1.0)
		self.played_amount = played
#		get_tree().call_group("Player Heal Recievers", "recieve_player_heal")
		if played == 1.0:
			despawn()
			self.holding = false
			self.playing = false



func score_note():
	scorable = false
	remove_from_group(scorable_group)
	scored = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if player_note:
			check_scorability()
			if holding:
				if playing:
					get_tree().call_group("Player Heal Recievers", "recieve_player_heal", healing_rate*delta)
				else:
					get_tree().call_group("Player Damage Recievers", "recieve_player_damage", damaging_rate*delta)
		else:
			check_auto_play()
#	if holding:
#		var song_time = get_parent().song_time
#		var played = range_lerp(song_time, hit_time, hit_time+hold_time, 0, 1)
#		self.played_amount = played
#	var hold_node = get_node(hold_note_body)
#	hold_node.scale.y = (hold_time/float(hold_node.texture.get_height()))/scale.y
#	get_node(hold_note_end).scale.y = 1.0/hold_node.scale.y
#	pass
