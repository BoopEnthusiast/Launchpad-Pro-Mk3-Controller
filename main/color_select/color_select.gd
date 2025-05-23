class_name ColorSelectPopup
extends Popup


signal color_selected(color_code: int)

const COLOR_SELECT_BUTTON = preload("res://main/color_select/color_select_button.tscn")

@onready var grid_container: GridContainer = $GridContainer


func _ready() -> void:
	for color: Color in Key.KEY_COLORS:
		var new_color_select_button: ColorSelectButton = COLOR_SELECT_BUTTON.instantiate() as ColorSelectButton
		grid_container.add_child(new_color_select_button)
		new_color_select_button.color = color
		new_color_select_button.pressed.connect(_on_color_select_button_pressed)


func _on_color_select_button_pressed(which_button: ColorSelectButton) -> void:
	color_selected.emit(grid_container.get_children().find(which_button))
	visible = false
