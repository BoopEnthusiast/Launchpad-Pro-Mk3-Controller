extends VBoxContainer


func _on_input_midi_port_selected(port: int) -> void:
	Midi.set_midi_in_midi(port)


func _on_output_midi_port_selected(port: int) -> void:
	Midi.set_midi_out_midi(port)


func _on_input_din_port_selected(port: int) -> void:
	Midi.set_midi_in_din(port)


func _on_output_din_port_selected(port: int) -> void:
	Midi.set_midi_out_din(port)


func _on_input_daw_port_selected(port: int) -> void:
	Midi.set_midi_in_daw(port)


func _on_output_daw_port_selected(port: int) -> void:
	Midi.set_midi_out_daw(port)
