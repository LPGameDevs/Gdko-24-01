extends Node

@onready var menu = $Menu
@onready var game = $Game
@onready var music = $Background

func _ready():
	SignalManager.StartGame.connect(_on_start_game);
	SignalManager.QuitGame.connect(_on_quit_game);
	SoundManager.play_sound(music, SoundManager.SOUND_IN_GAME);

func _on_start_game() -> void :
	menu.visible = false;
	game.visible = true;

func _on_quit_game() -> void :
	menu.visible = true;
	game.visible = false;
