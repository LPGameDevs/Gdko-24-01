extends CanvasLayer

func _on_settings_button_pressed():
	SignalManager.ToggleSettings.emit();

func _on_quit_button_pressed():
	SignalManager.QuitGame.emit();
