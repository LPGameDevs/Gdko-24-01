extends Screen

@onready var panel_container: PanelContainer = $PanelContainer


func _on_HomeButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/title.tscn")

func _on_RetryButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/Pong/game.tscn")

func _on_SettingsButton_pressed():
	pass # Replace with function body.
