extends Node2D

@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if !PlayerManager.player:
		var my_player = player.instantiate()
		PlayerManager.player = my_player
	get_tree().current_scene.add_child(PlayerManager.player)
	PlayerManager.player.global_position = Vector2(110,0)
	#Wwise.post_event_id(AK.EVENTS.GAMESTART_MENU, self)
	var cam = PlayerManager.player.get_node("Camera2D")
	cam.limit_left = -900
	cam.limit_right = 900
	cam.limit_top = -600
	cam.limit_bottom = 600
	Wwise.post_event_id(AK.EVENTS.GAMESTART_MENU, self)
	Wwise.post_event_id(AK.EVENTS.VALHALLA, self)
	HUD.visible = true
	# Wait a moment for the player to be fully initialized
	await get_tree().create_timer(0.1).timeout
	# Connect the HUD to player
	if not(HUD.connected):
		HUD.connect_to_player()
	#Inventory.connect_to_player()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_area_2d_tree_travel_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		get_tree().call_deferred("change_scene_to_file", "res://Tree_Scene/tree_scene.tscn")


func _on_area_2d_portal_travel_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		#PlayerManager.player.global_position = Vector2(0,520)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/Portal_Scene/Portal_Scene.tscn")
