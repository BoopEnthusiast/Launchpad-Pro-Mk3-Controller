class_name Presets
extends ScrollContainer


signal save_preset(file_name: String)
signal load_preset(file_name: String)

@onready var preset_name: LineEdit = $PresetsVBox/PresetName
@onready var select_preset: OptionButton = $PresetsVBox/SelectPreset


func _on_save_preset_pressed() -> void:
	save_preset.emit(preset_name.text)


func _on_load_preset_pressed() -> void:
	load_preset.emit(select_preset.get_item_text(select_preset.selected))
