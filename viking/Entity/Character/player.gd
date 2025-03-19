extends CharacterBody2D
@onready var _animated_sprite = $Sprite2D
@export var player_bullet: PackedScene = preload("res://Entity/Player/Magic_Bullet/Bullet.tscn")
#@export var SPEED : float = 300.0
const MAX_HEALTH = 100
#@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO

func _ready():
	#animation_tree.active = true
	add_to_group("Player")
	set_health_label()
	$HealthBar.max_value = MAX_HEALTH
	pass

func _process(_delta):
	if Input.is_action_pressed("map"):
		get_tree().change_scene_to_file("res://Map/map.tscn")
	set_health_bar()

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
		velocity = direction * Global.player_speed
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
	
func attack():
	pass
	

func set_health_bar() -> void:
	$HealthBar.value = Global.player_health
	if $HealthBar.value <= 0:
		get_tree().call_deferred("change_scene_to_file", "res://Game/GameOver/game_over.tscn")
	
func set_health_label() -> void:
	$HealthBarLabel.text = "Health: %s" % Global.player_health
	
