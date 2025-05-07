extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 8.0
const GRAVITY = 20.0
const MOUSE_SENSITIVITY = 0.002

@onready var camera_pivot = $Node3D/Camera3D
@export var projectile_scene: PackedScene

var rotation_y = 0.0  # Yaw
var rotation_x = 0.0  # Pitch

func _ready():
	add_to_group("house_player")
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
	if Input.is_action_just_pressed("escape"):
		#get_tree().current_scene.add_child(PlayerManager.player)
		#PlayerManager.player.global_position = Vector3(110,0,0)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		SceneTransitionManager.fade_to_scene("res://Map/Valhalla/home.tscn")
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

	var cam_forward = -$Node3D/Camera3D.global_transform.basis.z
	projectile.direction = cam_forward.normalized()

	get_parent().add_child(projectile)
	projectile.global_transform.origin = global_transform.origin + cam_forward * 1.5
