extends Node2D
@export var s_player: PackedScene = preload("res://Entities/Player/player.tscn")
@export var s_ice_golem: PackedScene = preload("res://Entities/Bosses/Ice_Golem/ice_golem.tscn")


var player = Node2D
var ice_golem = Node2D
var dead = false

var dialogue: DialogueUI
var cam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = PlayerManager.player
	if player == null:
		player = s_player.instantiate()
	get_tree().current_scene.add_child(player)
	player.global_position = Vector2(0, 500)
	player.direction = Vector2(0, 1)
	
	var dialogue_ui = player.get_node("DialogueUI")
	dialogue = dialogue_ui
	play_dialogue("res://Game/Dialogue/ymir-1.json")
	
	cam = player.get_node("Camera2D")
	cam.limit_left = -720
	cam.limit_right = 720
	cam.limit_top = -720
	cam.limit_bottom = 720
	
	
	ice_golem = s_ice_golem.instantiate()
	ice_golem.player = player
	ice_golem.global_position = Vector2(0, -525)
	get_tree().current_scene.add_child(ice_golem)
	ice_golem.get_node("CanvasLayer").visible = false
	
	get_window().content_scale_size = DisplayServer.window_get_size() *1.1
	dialogue.scale = Vector2(1.1, 1.1)
	ice_golem.get_node("CanvasLayer").scale = Vector2(1.1, 1.1)
	HUD.scale = Vector2(1.1, 1.1)
	Inventory.scale = Vector2(1.1, 1.1)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ice_golem == null and not dead:
		dead = true
		play_dialogue("res://Game/Dialogue/ymir-2.json")

	

func drop_artifact():
	$Artifact.visible = true
	$Artifact/CollisionShape2D.disabled = false

func _on_artifact_body_entered(body: Node2D) -> void:
	$Artifact.visible = false
	await get_tree().create_timer(.1).timeout
	portal_open()

func portal_open():
	$Portal.visible = true
	$Portal/CollisionShape2D.disabled = false
	$Portal/AnimatedSprite2D/AnimationPlayer.play("spin")
		
		
func _on_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		cam.limit_left = -10000000
		cam.limit_right = 10000000
		cam.limit_top = -10000000
		cam.limit_bottom = 10000000
		
		get_window().content_scale_size = DisplayServer.window_get_size()
		dialogue.scale = Vector2(1, 1)
		HUD.scale = Vector2(1, 1)
		Inventory.scale = Vector2(1, 1)

	
		remove_child(body)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/home.tscn")
		
func play_dialogue(path: String) -> void:
	modulate = Color.DIM_GRAY
	get_tree().paused = true
	dialogue.get_node("AnimationPlayer").play("Ymir")
	var words = dialogue.load_dialogue(path)
	dialogue.dialogue_begin(words)
	dialogue.connect("dialogue_finished", _on_dialogue_end)

func _on_dialogue_end():
	dialogue.disconnect("dialogue_finished", _on_dialogue_end)
	dialogue.get_node("AnimationPlayer").play("RESET")

	get_tree().paused = false
	modulate = Color.WHITE

	
	HUD.visible = true
	# Wait a moment for the player to be fully initialized
	await get_tree().create_timer(0.1).timeout
	# Connect the HUD to player
	HUD.connect_to_player()
	
	if ice_golem != null:
		ice_golem.get_node("CanvasLayer").visible = true
		await get_tree().create_timer(1).timeout
	else:
		drop_artifact()
