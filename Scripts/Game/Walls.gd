extends Node

func _on_left_body_entered(body):
#	body.direction.x *= -1;
	body.queue_free();
	var new_ball = preload("res://Scenes/Prefabs/Game/ball.tscn").instantiate();
	new_ball.global_position = Vector2(640, 427);
	add_child(new_ball);

func _on_top_body_entered(body):
	body.direction.y *= -1;

func _on_bottom_body_entered(body):
	body.direction.y *= -1;

func _on_right_body_entered(body):
#	body.direction.x *= -1;
	body.queue_free();
	var new_ball = preload("res://Scenes/Prefabs/Game/ball.tscn").instantiate();
	new_ball.global_position = Vector2(640, 427);
	add_child(new_ball);
