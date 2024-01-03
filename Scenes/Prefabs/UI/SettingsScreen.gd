extends Screen

@onready var panel_container: PanelContainer = $PanelContainer

func _ready() -> void:
	pass
	#if OS.has_feature('HTML5'):
		#exit_button.visible = false

func _show_screen(info: Dictionary = {}) -> void:
	#online_button.focus.grab_without_sound()
	ui_layer.hide_back_button()
