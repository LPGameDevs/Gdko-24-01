extends Node

func _on_left_body_entered(body: Ball):
	body.hit_goal();
	SignalManager.OnPlayerScored.emit("right");

func _on_top_body_entered(body: Ball):
	body.hit_wall();

func _on_bottom_body_entered(body: Ball):
	body.hit_wall();

func _on_right_body_entered(body: Ball):
	body.hit_goal();
	SignalManager.OnPlayerScored.emit("left");
