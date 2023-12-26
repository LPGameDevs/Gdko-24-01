extends Node

func _on_exit_button_pressed():
	get_tree().quit();


func _on_settings_button_pressed():
	SignalManager.ToggleSettings.emit();
	
