extends Node
## Manages the MIDI stuff for this informal launchpad application


signal midi_response(message: PackedByteArray)
signal din_response(message: PackedByteArray)
signal daw_response(message: PackedByteArray)

var midi_in_midi: MidiIn = MidiIn.new()
var midi_out_midi: MidiOut = MidiOut.new()
var midi_in_din: MidiIn = MidiIn.new()
var midi_out_din: MidiOut = MidiOut.new()
var midi_in_daw: MidiIn = MidiIn.new()
var midi_out_daw: MidiOut = MidiOut.new()

var queued_midi_responses: Array[Callable] = []
var queued_din_responses: Array[Callable] = []
var queued_daw_responses: Array[Callable] = []


func _ready() -> void:
	print_rich("\n[font_size=15][b]MIDI: Starting up MIDI singleton[/b][/font_size]\n")
	midi_in_midi.midi_message.connect(_on_midi_in_midi_message)
	midi_in_din.midi_message.connect(_on_midi_in_din_message)
	midi_in_daw.midi_message.connect(_on_midi_in_daw_message)
	midi_in_midi.ignore_types(false, false, false)
	midi_in_din.ignore_types(false, false, false)
	midi_in_daw.ignore_types(false, false, false)


func _on_midi_in_midi_message(_delta: float, message: PackedByteArray) -> void:
	_print("[i]MIDI:[/i] %s" % str(message))
	midi_response.emit.call_deferred(message)
	for callable: Callable in queued_midi_responses:
		callable.call_deferred(message)
	queued_midi_responses.clear()


func _on_midi_in_din_message(_delta: float, message: PackedByteArray) -> void:
	_print("[i]DIN:[/i] %s" % str(message))
	din_response.emit.call_deferred(message)
	for callable: Callable in queued_din_responses:
		callable.call_deferred(message)
	queued_din_responses.clear()


func _on_midi_in_daw_message(_delta: float, message: PackedByteArray) -> void:
	_print("[i]DAW:[/i] %s" % str(message))
	daw_response.emit.call_deferred(message)
	for callable: Callable in queued_daw_responses:
		callable.call_deferred(message)
	queued_daw_responses.clear()


## Sends a midi message to midi_out_midi
func send_midi_message(message: PackedByteArray) -> void:
	midi_out_midi.send_message(message)


## Send a midi message to midi_out_din
func send_din_message(message: PackedByteArray) -> void:
	midi_out_din.send_message(message)


## Send a midi message to midi_out_daw
func send_daw_message(message: PackedByteArray) -> void:
	midi_out_daw.send_message(message)


func set_midi_in_midi(port: int) -> void:
	midi_in_midi.close_port()
	midi_in_midi.open_port(port)
	_print_connected(MidiIn.get_port_name(port))


func set_midi_out_midi(port: int) -> void:
	midi_out_midi.close_port()
	midi_out_midi.open_port(port)
	_print_connected(MidiOut.get_port_name(port))


func set_midi_in_din(port: int) -> void:
	midi_in_din.close_port()
	midi_in_din.open_port(port)
	_print_connected(MidiIn.get_port_name(port))


func set_midi_out_din(port: int) -> void:
	midi_out_din.close_port()
	midi_out_din.open_port(port)
	_print_connected(MidiOut.get_port_name(port))


func set_midi_in_daw(port: int) -> void:
	midi_in_daw.close_port()
	midi_in_daw.open_port(port)
	_print_connected(MidiIn.get_port_name(port))


func set_midi_out_daw(port: int) -> void:
	midi_out_daw.close_port()
	midi_out_daw.open_port(port)
	_print_connected(MidiOut.get_port_name(port))


func _print_connected(to_print: String) -> void:
	_print("[i]Connected to:[/i] %s" % to_print)


func _print(to_print: String) -> void:
	print_rich("[b]MIDI:[/b] %s" % to_print)
