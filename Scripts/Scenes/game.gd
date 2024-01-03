extends CanvasLayer

@onready var ui_layer = $UILayer


func _ready():
	SignalManager.OnPlayerScored.connect(_on_player_scored)


func _on_settings_button_pressed():
	SignalManager.ToggleSettings.emit();

func _on_quit_button_pressed():
	SignalManager.QuitGame.emit();

func _on_player_scored(player: String):
	spawn_new_ball();

func spawn_new_ball() -> void:
	var new_ball = preload("res://Scenes/Prefabs/Game/ball.tscn").instantiate();
	new_ball.global_position = Vector2(640, 427);
	add_child(new_ball);


func _on_UILayer_back_button_pressed() -> void:
	print('action');
	print(ui_layer.current_screen_name);
	if ui_layer.current_screen_name in ['', 'SettingsScreen']:
		ui_layer.show_screen('PauseGameScreen')
		SignalManager.PauseGame.emit(true);
	else:
		ui_layer.hide_screen()
		SignalManager.PauseGame.emit(false);


func _on_UILayer_change_screen(name, screen, info):
	pass # Replace with function body.
