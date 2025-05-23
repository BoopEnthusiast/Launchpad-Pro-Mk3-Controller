extends GridContainer


const KEY: PackedScene = preload("res://main/key.tscn")

var last_pressed_key_child_index: int
var pressed_keys: Array[Key]

@onready var color_select_popup: ColorSelectPopup = $"../ColorSelectPopup"


func _ready() -> void:
	# Create the keys
	for i in range(64):
		var new_key: Key = KEY.instantiate() as Key
		add_child(new_key)
		new_key.pressed.connect(_key_pressed)
		var rand_color_index: int = randi_range(0, new_key.KEY_COLORS.size() - 64)
		new_key.color = new_key.KEY_COLORS[rand_color_index]
		# Set the color of the key on the actual launchpad
		var packet_to_send: PackedByteArray = [144, new_key.KEY_CODES[i], rand_color_index]
		Midi.send_midi_message.call_deferred(packet_to_send)
		Midi.send_daw_message.call_deferred(packet_to_send)
	
	Midi.daw_response.connect(_on_daw_response)


func _key_pressed(which_key: Key) -> void:
	last_pressed_key_child_index = get_children().find(which_key)
	color_select_popup.visible = true


func _on_color_select_popup_color_selected(color_code: int) -> void:
	var key: Key = get_child(last_pressed_key_child_index) as Key
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
