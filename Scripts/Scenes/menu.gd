extends CanvasLayer

func _on_exit_button_pressed():
	get_tree().quit();

func _on_settings_button_pressed():
	SignalManager.ToggleSettings.emit();

func _on_start_button_pressed():
	SignalManager.StartGame.emit();
