extends CheckButton


func _ready() -> void:
	# Assume I want drum mode on
	Midi.send_daw_message.call_deferred([240, 0, 32, 41, 2, 14, 15, 1, 247])


func _on_toggled(toggled_on: bool) -> void:
	var message: PackedByteArray = [240, 0, 32, 41, 2, 14, 15, 0, 247]
	if toggled_on:
		message[7] = 1
	Midi.send_daw_message(message)


func _exit_tree() -> void:
	# Turn off drum mode when the application closes, 
	# as per is recommended in the Launchpad Pro Mk3 Programmer's reference manual
	Midi.send_daw_message([240, 0, 32, 41, 2, 14, 15, 0, 247])
