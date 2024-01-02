extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

@export var side = 'left';

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
#    on_collision();
	pass;

func _physics_process(_delta):
	var direction;

	if side == 'left':
		direction = get_input(KEY_W, KEY_S);
	else:
		direction = get_input(KEY_UP, KEY_DOWN);

	if direction != Vector2.ZERO:
		direction = direction.normalized();
		velocity = direction * SPEED;
	else:
		velocity = Vector2.ZERO;

	move_and_slide();

func get_input(up, down):
	var direction = Vector2.ZERO;

	if Input.is_key_pressed(up):
		direction.y -= 1;
	if Input.is_key_pressed(down):
		direction.y += 1;

	return direction;

func on_collision():
	animation_player.play("hit");


func _on_player_area_body_entered(body):
	on_collision()
	body.direction.x *= -1;
