extends FontIconButton


@onready var select_preset: OptionButton = $"../SelectPreset" as OptionButton


func _on_pressed() -> void:
	var selected_file: String = select_preset.get_item_text(select_preset.selected)
	var new_config: ConfigFile = ConfigFile.new()
	var err = new_config.load("user://%s" % selected_file)
	if err != OK:
		printerr("Failed to load config file")
		return
	
