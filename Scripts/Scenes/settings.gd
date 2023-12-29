extends CanvasLayer

var _showingSettings: bool = false;

func _ready():
	SignalManager.ToggleSettings.connect(_on_toggle_settings);
	applyVisibility();

func applyVisibility() -> void :
	visible = _showingSettings;

func toggleVisibility() -> void :
	_showingSettings = !_showingSettings;
	applyVisibility();


func _on_toggle_settings() -> void:
	toggleVisibility();

func _on_close_button_pressed():
	toggleVisibility();
