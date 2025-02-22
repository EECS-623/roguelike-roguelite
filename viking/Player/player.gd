extends CharacterBody2D


@export var SPEED : float = 300.0

#@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO

func _ready():
	#animation_tree.active = true
	add_to_group("Player")
	pass

func _process(delta):
	#update_animation_parameters()
	
	pass
	
func _on_area_entered(area):
	if area.is_in_group("Portal"):
		get_tree().change_scene_to_file("res://Map/texture_rect.tscn")
		print("hello")
func _physics_process(delta):


	direction = Input.get_vector("left", "right","up","down").normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
