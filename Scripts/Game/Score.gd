extends Label

@export var _player: String = "left"

var _score: int = 0

func _ready() -> void:
	update_score();
	SignalManager.OnPlayerScored.connect(_on_player_scored);

func update_score() -> void:
	text = str(_score)

func _on_player_scored(player: String):
	if (player != _player):
		return;
	
	_score += 1;
	update_score();
