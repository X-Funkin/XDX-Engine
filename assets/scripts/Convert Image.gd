extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var size_x = get_viewport_rect().size.x
	var size_y = get_viewport_rect().size.y
#	$Control/AspectRatioContainer.ratio = float(size_y)/size_x
#	pass


func _on_Open_Image_pressed():
	$"Control/Image File Box".popup()

var base_image : Image
func _on_Image_File_Box_file_selected(path):
	var img = Image.new()
	img.load(path)
	base_image = img
	var tex = ImageTexture.new()
	tex.create_from_image(img)
#	$Control/AspectRatioContainer/CenterContainer/Sprite.texture = tex
	$Sprite.texture = tex
	if img.get_size().x >= img.get_size().y:
		$Sprite.scale = Vector2(1500.0/img.get_size().x,1500.0/img.get_size().x)
		return 0
	$Sprite.scale = Vector2(1000.0/img.get_size().y,1000.0/img.get_size().y)
	
#	$Control/CenterContainer/Sprite.texture = tex
	

var sprite_sheet_data : Array = []

func _on_XML_File_Box_file_selected(path):
	sprite_sheet_data = []
	var XMLParse = XMLParser.new()
	var ye = XMLParse.open(path)
#	var yomama = XMLParse.open(path)
#	var thingy = XMLParse.read()
#	print("xml")
#	print(thingy)
#	print(yomama)
	print(XMLParse)
#	XMLParse.skip_section()
#	XMLParse.skip_section()
#	XMLParse.skip_section()
#	XMLParse.skip_section()
	if ye != OK:
		print("oasdfh")
		return 0
	while true:
		if XMLParse.read() != OK:
			print("bruh")
#			return 0
			break
		if XMLParse.get_node_type() == XMLParse.NODE_ELEMENT:
			var data = {}
			print(XMLParse.get_attribute_count())
			for indx in range(XMLParse.get_attribute_count()):
				var data_name = XMLParse.get_attribute_name(indx)
				var data_value = XMLParse.get_attribute_value(indx)
				data[data_name] = data_value
#				print(XMLParse.get_attribute_name(indx))
#				print(XMLParse.get_attribute_value(indx))
#				print("\n")
			sprite_sheet_data.append(data)
	print("yeaaah man")
	for thing in sprite_sheet_data:
		if "name" in thing:
			thing["x"] = int(thing["x"])
			thing["y"] = int(thing["y"])
			thing["width"] = int(thing["width"])
			thing["height"] = int(thing["height"])
#		print(thing)
	$Sprite/XMLVis.update()

func _on_Open_XML_pressed():
	$"Control/XML File Box".popup()

func export_image_sequence(dir):
	print("EXPORTING")
	base_image.lock()
	for sprite in sprite_sheet_data:
		if "name" in sprite:
			print("EXPORTING ", sprite["name"])
			var sprite_image = Image.new()
			sprite_image.create(sprite["width"],sprite["height"], false, base_image.get_format())
			sprite_image.lock()
			for x in range(sprite["width"]):
				for y in range(sprite["height"]):
					sprite_image.set_pixel(x,y,base_image.get_pixel(sprite["x"]+x,sprite["y"]+y))
			sprite_image.save_png("%s/%s.png"%[dir,sprite["name"]])
	base_image.unlock()
	print("EXPORTED")
func _on_Export_Images_Box_dir_selected(dir):
	print(dir)
	export_image_sequence(dir)


func _on_Export_Images_pressed():
	$"Control/Export Images Box".popup()
