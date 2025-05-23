class_name ModeSelect
extends OptionButton


var just_set_mode: bool = false


func _ready() -> void:
	Midi.daw_response.connect(_on_daw_response)
	# Wait for the DAW mode to be set first
	await get_tree().process_frame
	# Set the session to default
	Midi.send_midi_message.call_deferred([240, 0, 32, 41, 2, 14, 0, 0, 0, 0, 247])


func _on_daw_response(message: PackedByteArray) -> void:
	if not just_set_mode and message[0] == 240 and message[1] == 0 and message[2] == 32 and message[3] == 41 and message[4] == 2 and message[5] == 14 and message[6] == 0 and message[9] == 0 and message[10] == 247:
		selected = message[7]
		just_set_mode = false


func _on_item_selected(index: int) -> void:
	Midi.send_midi_message([240, 0, 32, 41, 2, 14, 0, index, 0, 0, 247])
	just_set_mode = true
