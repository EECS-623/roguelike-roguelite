extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var player_bullet: PackedScene = preload("res://Entities/Player/Magic_Bullet/Bullet.tscn")
#@export var SPEED : float = 300.0
#@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_tree.active = true
	add_to_group("player")
	set_health_label()
	$HealthBar.max_value = $HealthComponent.max_health
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	if Input.is_action_pressed("map"):
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.queue_free()

		get_tree().change_scene_to_file("res://Map/map.tscn")
	set_health_bar()

func _unhandled_input(event):
	#if event is InputEventMouseButton and event.pressed:
		#shoot()
	pass
		
func _physics_process(_delta):

	direction = Input.get_vector("left", "right","up","down").normalized()
	var current = "move_right"
	var up = "move_up"
	var down = "move_down"
	if direction.x < 0:
		_animated_sprite.flip_h = true
		velocity = direction * Global.player_speed
		_animated_sprite.play(current)
		
	elif direction.x > 0:
		_animated_sprite.flip_h = false
		velocity = direction * Global.player_speed
		_animated_sprite.play(current)
		
	elif direction.y <0:
		_animated_sprite.flip_h = false
		velocity = direction * Global.player_speed
		_animated_sprite.play(up)
		
	elif direction.y >0:
		_animated_sprite.flip_h = false
		velocity = direction * Global.player_speed
		_animated_sprite.play(down)
		
	else:
		velocity = Vector2.ZERO
		_animated_sprite.frame = 1
		_animated_sprite.stop()

	move_and_slide()

#func shoot():
	#var bullet = player_bullet.instantiate()
	#get_tree().current_scene.add_child(bullet)
	
	#bullet.position = global_position
	#bullet.direction = (get_global_mouse_position() - global_position).normalized()

func _perform_melee_attack():
	print("attack")

func set_health_bar() -> void:
	$HealthBar.value = $HealthComponent.current_health

func set_health_label() -> void:
	$HealthBarLabel.text = "Health: %s" % $HealthComponent.current_health

func _on_health_component_death() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Game/GameOver/game_over.tscn")
	#queue_free()
