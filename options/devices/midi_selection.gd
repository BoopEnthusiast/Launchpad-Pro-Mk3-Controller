class_name MidiDeviceSelection
extends OptionButton


signal port_selected(port: int)

enum MidiSingletons {
	MIDI_IN,
	MIDI_OUT,
}

@export var midi_selection: MidiSingletons
@export var string_to_check_for: String


func _ready() -> void:
	_refresh()


func _on_refresh_devices_pressed() -> void:
	_refresh()


func _on_item_selected(index: int) -> void:
	port_selected.emit(index)


func _refresh() -> void:
	clear()
	# Get the relevant port names
	var port_names: PackedStringArray
	match midi_selection:
		MidiSingletons.MIDI_IN:
			port_names = MidiIn.get_port_names()
		MidiSingletons.MIDI_OUT:
			port_names = MidiOut.get_port_names()
	# Add items for each port name and pre-select the wanted one
	var i: int = 0
	for device: String in port_names:
		# Add the item without the text before and including the :
		add_item(device.get_slice(":", 1))
		# Pre-select the thing I probably want
		if device.contains("ProMK3") and device.contains(string_to_check_for):
			selected = i
			port_selected.emit(i)
		i += 1
