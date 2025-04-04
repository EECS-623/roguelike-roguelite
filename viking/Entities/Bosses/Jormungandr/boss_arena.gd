extends Node2D
@export var s_player: PackedScene = preload("res://Entities/Player/player.tscn")
@export var s_snake: PackedScene 


var player = Node2D
var snake = Node2D
var snake_dead = false
var health_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = s_player.instantiate()
	get_tree().current_scene.add_child(player)
	
	snake = s_snake.instantiate()
	get_tree().current_scene.add_child(snake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if snake == null and not snake_dead:
		snake_dead = true
		portal_open()
	elif snake != null:
		snake.chase_player(player.global_position)
	
	if player.get_node("Hurtbox").health_component.current_health <= 0:
		print("PLAYER DIED")

func portal_open():
	$Portal.visible = true
	$Portal/CollisionShape2D.disabled = false
	$Portal/AnimatedSprite2D/AnimationPlayer.play("spin")
		
		
func _on_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			#$CollisionShape2D.set_deferred("disabled", true)
			get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/home.tscn")
