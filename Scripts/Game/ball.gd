extends CharacterBody2D

class_name Ball

@export var SPEED = 30000.0

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var direction = Vector2.ZERO

var stop_animation: bool = false;

func _ready():
	direction.x = [0.5, 1, -0.5, -1].pick_random();
	direction.y = [0.5, 1, -0.5, -1].pick_random();
	#direction.x = [1, -1].pick_random();
	#direction.y = [1, -1].pick_random();
	animation_player.play("ball_rolling");

func _physics_process(delta):
	handle_rotation();

	if direction:
		velocity = direction.normalized() * SPEED * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * delta)

	move_and_slide()

func handle_rotation():
	match direction:
		Vector2(1, 1):
			rotation_degrees = 45
		Vector2(1, -1):
			rotation_degrees = -45
		Vector2(-1, 1):
			rotation_degrees = 135
		Vector2(-1, -1):
			rotation_degrees = -135
		Vector2(1, 0.5):
			rotation_degrees = 22.5
		Vector2(1, -0.5):
			rotation_degrees = -22.5
		Vector2(-1, 0.5):
			rotation_degrees = 157.5
		Vector2(-1, -0.5):
			rotation_degrees = -157.5
		Vector2(0.5, 1):
			rotation_degrees = 67.5
		Vector2(0.5, -1):
			rotation_degrees = -67.5
		Vector2(-0.5, 1):
			rotation_degrees = 112.5
		Vector2(-0.5, -1):
			rotation_degrees = -112.5
		Vector2(0.5, 0.5):
			rotation_degrees = 45
		Vector2(0.5, -0.5):
			rotation_degrees = -45
		Vector2(-0.5, 0.5):
			rotation_degrees = 135
		Vector2(-0.5, -0.5):
			rotation_degrees = -135
		Vector2(0, 0.5):
			rotation_degrees = 90
		Vector2(0, -0.5):
			rotation_degrees = -90

func hit_wall() -> void:
	direction.y *= -1;

func hit_goal() -> void:
	#direction.x *= -1;
	queue_free()


