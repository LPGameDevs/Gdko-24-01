extends Screen

@onready var panel_container: PanelContainer = $PanelContainer
@onready var margin_container
@onready var exit_button = $PanelContainer/MarginContainer/VBoxContainer/ExitButton

func _ready() -> void:
	if OS.has_feature('HTML5'):
		exit_button.visible = false

func _show_screen(info: Dictionary = {}) -> void:
	#online_button.focus.grab_without_sound()
	ui_layer.hide_back_button()

func _on_LocalButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Pong/game.tscn")

func _on_OnlineButton_pressed() -> void:
	#get_tree().change_scene_to_file("res://src/main/SessionSetup.tscn")
	pass;

func _on_SettingsButton_pressed() -> void:
	ui_layer.show_screen("SettingsScreen")

func _on_CreditsButton_pressed() -> void:
	ui_layer.show_screen("CreditsScreen")

func _on_ExitButton_pressed() -> void:
	get_tree().quit()
