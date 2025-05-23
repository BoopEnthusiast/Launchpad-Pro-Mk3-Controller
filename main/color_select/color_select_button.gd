class_name ColorSelectButton
extends ColorRect


signal pressed(which_button: ColorSelectButton)


func _on_button_pressed() -> void:
	pressed.emit(self)
