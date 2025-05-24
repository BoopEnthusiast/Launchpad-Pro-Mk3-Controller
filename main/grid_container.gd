extends GridContainer


const KEY: PackedScene = preload("res://main/key.tscn")

var last_pressed_key_child_index: int
var pressed_keys: Array[Key]

@onready var color_select_popup: ColorSelectPopup = $"../ColorSelectPopup"


func _ready() -> void:
	# Create the keys
	for i in range(64):
		_create_new_key(Key.KEY_COLORS.pick_random(), i)
	
	Midi.daw_response.connect(_on_daw_response)


func _send_colors() -> void:
	var i: int = 0
	for key: Key in get_children():
		var color_code: int = key.KEY_COLORS.find(key.color)
		var packet_to_send: PackedByteArray = [144, key.KEY_CODES[i], color_code]
		Midi.send_midi_message.call_deferred(packet_to_send)
		Midi.send_daw_message.call_deferred(packet_to_send)
		i += 1


func _create_new_key(color: Color, child_index: int) -> void:
	var new_key: Key = KEY.instantiate()
	add_child(new_key)
	new_key.pressed.connect(_key_pressed)
	new_key.color = color
	var packet_to_send: PackedByteArray = [144, new_key.KEY_CODES[child_index], new_key.KEY_COLORS.find(color)]
	print(packet_to_send)
	Midi.send_midi_message.call_deferred(packet_to_send)
	Midi.send_daw_message.call_deferred(packet_to_send)


func _key_pressed(which_key: Key) -> void:
	last_pressed_key_child_index = get_children().find(which_key)
	color_select_popup.visible = true


func _on_color_select_popup_color_selected(color_code: int) -> void:
	var key: Key = get_child(last_pressed_key_child_index)
	key.color = key.KEY_COLORS[color_code]
	# Set the color of the key on the actual launchpad
	var packet_to_send = [144, key.KEY_CODES[last_pressed_key_child_index], color_code]
	Midi.send_midi_message.call_deferred(packet_to_send)
	Midi.send_daw_message.call_deferred(packet_to_send)


func _on_daw_response(message: PackedByteArray) -> void:
	if message[0] == 144:
		if message[2] == 0:
			var key_to_erase: Key = get_child(Key.KEY_CODES.find(message[1])) as Key
			pressed_keys.erase(key_to_erase)
			key_to_erase.color = key_to_erase.reserve_color
		else:
			var pressed_key: Key = get_child(Key.KEY_CODES.find(message[1])) as Key
			pressed_keys.append(pressed_key)
			pressed_key.temp_color = Color.from_ok_hsl(0.9, 0.8, message[2] / 127.0)


func _on_options_send_color() -> void:
	_send_colors()


func _on_presets_save_preset(file_name: String) -> void:
	if file_name.is_empty():
		printerr("Config file name was not given")
		return
	
	var new_file_name: String = "%s.cfg" % file_name
	var config_file: ConfigFile = ConfigFile.new()
	
	var i: int = 0
	for child: Key in get_children():
		config_file.set_value("Key colors", str(i), child.color)
		i += 1
	
	config_file.save("user://%s" % new_file_name)


func _on_presets_load_preset(file_name: String) -> void:
	var config_file: ConfigFile = ConfigFile.new()
	var err = config_file.load("user://%s" % file_name)
	if err != OK:
		printerr("Failed to load config file")
		return
	
	for child: Key in get_children():
		remove_child(child)
	for i in range(64):
		print(config_file.get_value("Key colors", str(i), Color.BLACK))
		_create_new_key(config_file.get_value("Key colors", str(i), Color.BLACK), i)
	
	_send_colors()
