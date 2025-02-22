extends CharacterBody2D
@onready var _animated_sprite = $Sprite2D

@export var SPEED : float = 300.0

#@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO

func _ready():
	#animation_tree.active = true
	add_to_group("Player")
	pass

func _process(delta):
	#update_animation_parameters()
	if Input.is_action_just_pressed("map"):
		get_tree().change_scene_to_file("res://Map/map.tscn")
	
	
func _on_area_entered(area):
	if area.is_in_group("Portal"):
		get_tree().change_scene_to_file("res://Map/map.tscn")
		print("hello")
func _physics_process(delta):


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
	
	
