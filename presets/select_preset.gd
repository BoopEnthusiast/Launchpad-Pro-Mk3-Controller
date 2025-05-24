extends OptionButton


func _ready() -> void:
	clear()
	for file: String in DirAccess.get_files_at("user://"):
		if file.ends_with(".cfg"):
			add_item(file)
