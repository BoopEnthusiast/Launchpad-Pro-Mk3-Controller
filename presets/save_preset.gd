extends FontIconButton


@onready var preset_name: LineEdit = $"../PresetName"


func _on_pressed() -> void:
	var file_name = "%s.cfg" % preset_name.text
	var config_file: ConfigFile = ConfigFile.new()
	
