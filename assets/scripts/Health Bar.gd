tool
extends Node2D
class_name HealtBar

# Export Vary Bles

export(bool) var flip_player_icon = true setget set_flip_player_icon
export(float) var player_icon_offset = 50.0 setget set_player_icon_offset
export(float) var player_icon_scale = 1.0 setget set_player_icon_scale
export(Texture) var player_losing_icon setget set_player_losing_icon
export(Texture) var player_icon setget set_player_icon
export(Texture) var player_winning_icon setget set_player_winning_icon

export(bool) var flip_enemy_icon = false setget set_flip_enemy_icon
export(float) var enemy_icon_offset = -50.0 setget set_enemy_icon_offset
export(float) var enemy_icon_scale = 1.0 setget set_enemy_icon_scale
export(Texture) var enemy_losing_icon setget set_enemy_losing_icon
export(Texture) var enemy_icon setget set_enemy_icon
export(Texture) var enemy_winning_icon setget set_enemy_winning_icon
export(float) var health_icons_scale = 0.5 setget set_health_icons_scale

export(Color) var health_color = Color("00FF00") setget set_health_color
export(Color) var damage_color = Color("FF0000") setget set_damage_color

export(float, 0.0, 100.0) var health = 50.0 setget set_health
export(float) var winning_health = 70.0 setget set_winning_health
export(float) var losing_health = 20.0 setget set_losing_health
export(int, "Hit Based", "Accuracy Based", "Judgment Based") var healing_mode
export(float) var healing_multiplier = 1.0
export(float) var damage_multiplier = 1.0
#export(int, "Player", "Nobody", "Enemy") var whos_winning = 1
#export(float) var icon_distance = 100.0

#more vars

var health_bar_sprite : NodePath = @"Health Bar Sprite"
var icon_sprite_position : NodePath = @"Icon Sprite Position"
var player_icon_sprite : NodePath = @"Icon Sprite Position/Player Health Icon"
var enemy_icon_sprite : NodePath = @"Icon Sprite Position/Enemy Health Icon"


#uuuugh teh supid settergetters i have to tyPE THEM IN MANUALLY AAAA

func set_health(n_health):
	health = clamp(n_health,0.0,100.0)
	
	if not is_inside_tree(): yield(self, 'ready')
	update_sprite_position()
	update_health_bar_sprite()
	check_winning()
	pass

func set_winning_health(n_health):
	winning_health = n_health
	if not is_inside_tree(): yield(self, 'ready')
	check_winning()

func set_losing_health(n_health):
	losing_health = n_health
	if not is_inside_tree(): yield(self, 'ready')
	check_winning()

func set_health_icons_scale(n_scale):
	health_icons_scale = n_scale
	if not is_inside_tree(): yield(self, 'ready')
	get_node(icon_sprite_position).scale = Vector2(health_icons_scale, health_icons_scale)

func set_flip_player_icon(n_flip):
	flip_player_icon = n_flip
	if not is_inside_tree(): yield(self, 'ready')
	get_node(player_icon_sprite).flip_h = n_flip

func set_player_icon_offset(n_offset):
	player_icon_offset = n_offset
	if not is_inside_tree(): yield(self, 'ready')
	get_node(player_icon_sprite).position.x = player_icon_offset

func set_player_icon_scale(n_scale):
	player_icon_scale = n_scale
	if not is_inside_tree(): yield(self, 'ready')
	get_node(player_icon_sprite).scale = Vector2(player_icon_scale,player_icon_scale)

func set_player_losing_icon(n_icon):
	player_losing_icon = n_icon
	if not is_inside_tree(): yield(self, 'ready')
	get_node(player_icon_sprite).texture = n_icon

func set_player_icon(n_icon):
	player_icon = n_icon
	if not is_inside_tree(): yield(self, 'ready')
	get_node(player_icon_sprite).texture = n_icon

func set_player_winning_icon(n_icon):
	player_winning_icon = n_icon
	if not is_inside_tree(): yield(self, 'ready')
	get_node(player_icon_sprite).texture = n_icon


func set_flip_enemy_icon(n_flip):
	flip_enemy_icon = n_flip
	if not is_inside_tree(): yield(self, 'ready')
	get_node(enemy_icon_sprite).flip_h = n_flip

func set_enemy_icon_offset(n_offset):
	enemy_icon_offset = n_offset
	if not is_inside_tree(): yield(self, 'ready')
	get_node(enemy_icon_sprite).position.x = enemy_icon_offset

func set_enemy_icon_scale(n_scale):
	enemy_icon_scale = n_scale
	if not is_inside_tree(): yield(self, 'ready')
	get_node(enemy_icon_sprite).scale = Vector2(enemy_icon_scale,enemy_icon_scale)


func set_enemy_losing_icon(n_icon):
	enemy_losing_icon = n_icon
	if not is_inside_tree(): yield(self, 'ready')
	get_node(enemy_icon_sprite).texture = n_icon

func set_enemy_icon(n_icon):
	enemy_icon = n_icon
	if not is_inside_tree(): yield(self, 'ready')
	get_node(enemy_icon_sprite).texture = n_icon

func set_enemy_winning_icon(n_icon):
	enemy_winning_icon = n_icon
	if not is_inside_tree(): yield(self, 'ready')
	get_node(enemy_icon_sprite).texture = n_icon


func set_health_color(n_color):
	health_color = n_color
	if not is_inside_tree(): yield(self, 'ready')
	var shader = get_node(health_bar_sprite).material
	shader.set_shader_param("Health_Color",health_color)

func set_damage_color(n_color):
	damage_color = n_color
	if not is_inside_tree(): yield(self, 'ready')
	var shader = get_node(health_bar_sprite).material
	shader.set_shader_param("Damage_Color",damage_color)

#more funcss

func update_health_bar_sprite():
	var shader = get_node(health_bar_sprite).material
	shader.set_shader_param("Health",health/100.0)
	pass

func update_sprite_position():
	var width = float(get_node(health_bar_sprite).texture.get_width())
	print(width)
	var pos = lerp(width/2.0,-width/2.0,health/100.0)
	print(pos)
	get_node(icon_sprite_position).position.x = pos
	print(get_node(icon_sprite_position).position.x)


func check_winning():
	if health <= 0.0:
		get_tree().call_group("Player Death Recievers", "recieve_player_death")
	elif health >= winning_health:
		player_winning()
	elif health <= losing_health:
		player_losing()
	else:
		nobody_winning()

func player_winning():
	get_node(player_icon_sprite).texture = player_winning_icon
	get_node(enemy_icon_sprite).texture = enemy_losing_icon

func player_losing():
	get_node(player_icon_sprite).texture = player_losing_icon
	get_node(enemy_icon_sprite).texture = enemy_winning_icon

func nobody_winning():
	get_node(player_icon_sprite).texture = player_icon
	get_node(enemy_icon_sprite).texture = enemy_icon

# recieverssss agopiuwsadfjasf
func recieve_player_hit(note : Note, hit_error):
	self.health += 10
#	pass

func recieve_player_miss(note_type):
	self.health -= 10

func recieve_player_heal(n_heal):
	self.health += n_heal*healing_multiplier

func recieve_player_damage(n_damage):
	self.health -= n_damage*damage_multiplier

#	pass

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.health = health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
