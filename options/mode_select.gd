class_name ModeSelect
extends OptionButton


var just_set_mode: bool = false


func _ready() -> void:
	_get_current_mode.call_deferred()
	Midi.daw_response.connect(_on_daw_response)


func _get_current_mode() -> void:
	Midi.send_midi_message([240, 0, 32, 41, 2, 14, 0, 247])
	Midi.queued_midi_responses.append(_get_current_layout)


func _get_current_layout(response: PackedByteArray) -> void:
	selected = response[7]


func _on_daw_response(message: PackedByteArray) -> void:
	if not just_set_mode and message[0] == 240 and message[1] == 0 and message[2] == 32 and message[3] == 41 and message[4] == 2 and message[5] == 14 and message[6] == 0 and message[9] == 0 and message[10] == 247:
		selected = message[7]
		just_set_mode = false


func _on_item_selected(index: int) -> void:
	Midi.send_midi_message([240, 0, 32, 41, 2, 14, 0, index, 0, 0, 247])
	just_set_mode = true
