extends Node2D
@export var s_player: PackedScene = preload("res://Entities/Player/player.tscn")
@export var s_ice_golem: PackedScene = preload("res://Entities/Bosses/Ice_Golem/ice_golem.tscn")


var player = Node2D
var ice_golem = Node2D
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = s_player.instantiate()
	get_tree().current_scene.add_child(player)
	player.global_position = Vector2(0, 500)
	
	var cam = player.get_node("Camera2D")
	cam.limit_left = -720
	cam.limit_right = 720
	cam.limit_top = -720
	cam.limit_bottom = 720
	
	
	ice_golem = s_ice_golem.instantiate()
	ice_golem.player = player
	ice_golem.global_position = Vector2(0, -525)
	get_tree().current_scene.add_child(ice_golem)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ice_golem == null and not dead:
		dead = true
		portal_open()
	
	
func portal_open():
	$Portal.visible = true
	$Portal/CollisionShape2D.disabled = false
	$Portal/AnimatedSprite2D/AnimationPlayer.play("spin")
		
		
func _on_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/home.tscn")
