extends CharacterBody2D


@export var SPEED = 30000.0
var direction = Vector2.ZERO

func _ready():
	direction.x = [0.5, 1, -0.5, -1].pick_random();
	direction.y = [0.5, 1, -0.5, -1].pick_random();

func _physics_process(delta):
	if direction:
		velocity = direction.normalized() * SPEED * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * delta)

	print(delta);
	print(direction);

	move_and_slide()
