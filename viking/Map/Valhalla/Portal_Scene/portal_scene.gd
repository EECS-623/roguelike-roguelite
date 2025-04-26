extends Node2D

@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if !PlayerManager.player:
		var my_player = player.instantiate()
		PlayerManager.player = my_player
	PlayerManager.player.global_position = Vector2(0,-550)
	get_tree().current_scene.add_child(PlayerManager.player)
	#Wwise.post_event_id(AK.EVENTS.GAMESTART_MENU, self)
	var cam = PlayerManager.player.get_node("Camera2D")
	cam.limit_left = -600
	cam.limit_right = 600
	cam.limit_top = -600
	cam.limit_bottom = 600
	Wwise.post_event_id(AK.EVENTS.VALHALLA, self)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass



func _on_area_2d_go_home_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/home.tscn")


func _on_area_2d_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		if Global.world_level == 1:
			
			get_tree().call_deferred("change_scene_to_file", "res://Map/Forest Realm/earth_tileset.tscn")
			Global.world_level = 2
		elif Global.world_level == 2:
			get_tree().call_deferred("change_scene_to_file", "res://Map/Ice Realm/ice_tileset.tscn")
		var cam = PlayerManager.player.get_node("Camera2D")
		cam.limit_left = -10000000
		cam.limit_right = 10000000
		cam.limit_top = -10000000
		cam.limit_bottom = 10000000
