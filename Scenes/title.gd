extends Node

@onready var ui_layer = $UILayer
@onready var music = $Music

func _ready():
	SoundManager.play_sound(music, SoundManager.SOUND_IN_GAME);
	ui_layer.show_screen("StartScreen")

