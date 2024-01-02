extends CanvasLayer

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
