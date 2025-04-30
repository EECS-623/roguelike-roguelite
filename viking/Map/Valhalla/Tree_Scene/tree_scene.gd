extends Node2D

@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !PlayerManager.player:
		var my_player = player.instantiate()
		PlayerManager.player = my_player
	get_tree().current_scene.add_child(PlayerManager.player)
	PlayerManager.player.global_position = Vector2(0,500)
	Wwise.post_event_id(AK.EVENTS.GAMESTART_MENU, self)
	var cam = PlayerManager.player.get_node("Camera2D")
	cam.limit_left = -900
	cam.limit_right = 900
	cam.limit_top = -600
	cam.limit_bottom = 600
	Wwise.post_event_id(AK.EVENTS.VALHALLA, self)

	if Global.loki_reveal:
		$AnimatedSprite2D/AnimationPlayer.play("turn_and_leave")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass





func _on_area_2d_home_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/home.tscn")


func _on_area_2d_to_loki_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Global.loki_reveal:
		Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		get_tree().call_deferred("change_scene_to_file", "res://Entities/Bosses/Loki/boss_arena.tscn")
