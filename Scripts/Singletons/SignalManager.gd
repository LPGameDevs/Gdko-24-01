extends Node

# UI
signal ToggleSettings();

# Game setup
signal StartGame();
signal PauseGame(is_paused: bool);
signal QuitGame();

# Scores
signal OnPlayerScored(player: String);
