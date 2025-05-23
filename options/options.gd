extends ScrollContainer


signal send_color()


func _on_send_color_pressed() -> void:
	send_color.emit()
