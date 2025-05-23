extends GridContainer


const KEY: PackedScene = preload("res://main/key.tscn")

var last_pressed_key_child_index: int

@onready var color_select_popup: ColorSelectPopup = $"../ColorSelectPopup"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(64):
		var new_key: Key = KEY.instantiate() as Key
		add_child(new_key)
		new_key.pressed.connect(_key_pressed)
		var rand_color_index: int = randi_range(0, new_key.KEY_COLORS.size() - 64)
		new_key.color = new_key.KEY_COLORS[rand_color_index]
		var packet_to_send: PackedByteArray = [144, new_key.KEY_CODES[i], rand_color_index]
		Midi.send_midi_message.call_deferred(packet_to_send)


func _key_pressed(which_key: Key) -> void:
	last_pressed_key_child_index = get_children().find(which_key)
	color_select_popup.visible = true


func _on_color_select_popup_color_selected(color_code: int) -> void:
	var key: Key = get_child(last_pressed_key_child_index) as Key
	key.color = key.KEY_COLORS[color_code]
	Midi.send_midi_message([144, key.KEY_CODES[last_pressed_key_child_index], color_code])
