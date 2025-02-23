extends CharacterBody2D
@onready var _animated_sprite = $Sprite2D
@export var player_bullet: PackedScene = preload("res://Magic_Bullet/Bullet.tscn")
@export var SPEED : float = 300.0

#@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO

func _ready():
	#animation_tree.active = true
	add_to_group("Player")
	pass

func _process(_delta):
	if Input.is_action_pressed("map"):
		get_tree().change_scene_to_file("res://Map/map.tscn")
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		shoot()
		
func _physics_process(_delta):


	direction = Input.get_vector("left", "right","up","down").normalized()
	if direction.x < 0:
		_animated_sprite.flip_h = true
	elif direction.x > 0:
		_animated_sprite.flip_h = false
	if direction:
		velocity = direction * SPEED
		_animated_sprite.play("run")
	else:
		velocity = Vector2.ZERO
		_animated_sprite.stop()

	move_and_slide()

func shoot():
	var bullet = player_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
