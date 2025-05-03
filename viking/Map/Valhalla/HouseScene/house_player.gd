extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 8.0
const GRAVITY = 20.0
const MOUSE_SENSITIVITY = 0.002

@onready var camera_pivot = $Node3D/Camera3D
@export var projectile_scene: PackedScene

var rotation_y = 0.0  # Yaw
var rotation_x = 0.0  # Pitch

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * MOUSE_SENSITIVITY
		rotation_x -= event.relative.y * MOUSE_SENSITIVITY
		rotation_x = clamp(rotation_x, deg_to_rad(-80), deg_to_rad(80))  # limit pitch

		rotation.y = rotation_y
		camera_pivot.rotation.x = rotation_x

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("down"):
		direction += transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("right"):
		direction += transform.basis.x

	direction.y = 0
	direction = direction.normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		if Input.is_action_just_pressed("special_ability"):
			velocity.y = JUMP_VELOCITY

	move_and_slide()


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()

func shoot():
	var projectile = projectile_scene.instantiate()

	# Set direction before adding to scene
	projectile.direction = -transform.basis.z

	get_parent().add_child(projectile)

	# Set initial position in front of player
	projectile.global_transform.origin = global_transform.origin + projectile.direction * 1.5
