extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int, "XML Convert", "Contrast Max") var mode

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/OptionButton.add_item("Convert XML Sprite Sheet", 0)
	$Control/OptionButton.add_item("maximise contrast", 1)
#	$Control/OptionButton.add_item("yoowyas3")
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



func export_max_contrast_img(path):
	base_image.lock()
	var min_val = base_image.get_pixel(0,0).r
	var max_val = base_image.get_pixel(0,0).r
	for x in range(base_image.get_width()):
		for y in range(base_image.get_height()):
			var new_color = base_image.get_pixel(x,y)
			min_val = [min_val,new_color.r,new_color.g,new_color.b].min()
			max_val = [max_val,new_color.r,new_color.g,new_color.b].max()
	var max_con_img = Image.new()
	max_con_img.copy_from(base_image)
	max_con_img.lock()
	for x in range(max_con_img.get_width()):
		for y in range(max_con_img.get_height()):
			var pixel = max_con_img.get_pixel(x,y)
			pixel.r = range_lerp(pixel.r,min_val,max_val,0,1)
			pixel.g = range_lerp(pixel.g,min_val,max_val,0,1)
			pixel.b = range_lerp(pixel.b,min_val,max_val,0,1)
			max_con_img.set_pixel(x,y,pixel)
	max_con_img.save_png(path)
	base_image.unlock()
	print("DONE")

func _on_Export_Images_Box_dir_selected(dir):
	print(dir)
	export_image_sequence(dir)


func _on_Export_Images_pressed():
	match mode:
		0:
			$"Control/Export Images Box".popup()
		1:
			$"Control/Export Image Box".popup()


func _on_Export_Image_Box_file_selected(path):
	print(path)
	export_max_contrast_img(path)


func _on_OptionButton_item_selected(index):
	mode = index
