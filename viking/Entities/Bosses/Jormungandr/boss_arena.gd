extends Node2D
@export var s_player: PackedScene = preload("res://Entities/Player/player.tscn")
@export var s_snake: PackedScene 

var player = Node2D
var snake = Node2D
var snake_dead = false

var dialogue: DialogueUI
var cam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Wwise.register_game_obj(self, self.name)
	#Wwise.register_listener(self)
	#Wwise.load_bank_id(AK.BANKS.MUSIC_SFX)
	#Wwise.post_event_id(AK.EVENTS.MAP_LOADED, self)
	#Wwise.post_event_id(AK.EVENTS.ALIVE, self)
	#Wwise.post_event_id(AK.EVENTS.MIDGARD, self)
	#comment out above for real full play through.

	#Wwise.post_event_id(AK.EVENTS.GAMEPLAY, self)
	Wwise.post_event_id(AK.EVENTS.PREBOSS, self)
	player = PlayerManager.player
	if player == null:
		player = s_player.instantiate()
	
	get_tree().current_scene.add_child(player)
	
	
	
	player.position = Vector2(0,400)
	snake = s_snake.instantiate()
	get_tree().current_scene.add_child(snake)
	snake.get_node("CanvasLayer").visible = false

	
	var dialogue_ui = player.get_node("DialogueUI")
	dialogue = dialogue_ui
	play_dialogue("res://Game/Dialogue/jormungandr-1.json")
	
	pulse_thorns()
	Wwise.post_event_id(AK.EVENTS.BOSS, self)
	
	cam = player.get_node("Camera2D")
	cam.limit_left = -900
	cam.limit_right = 900
	cam.limit_top = -900
	cam.limit_bottom = 900
	cam.zoom = Vector2(.75, .75)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if snake == null and not snake_dead:
		snake_dead = true
		play_dialogue("res://Game/Dialogue/jormungandr-2.json")
		drop_artifact()

	elif snake != null:
		snake.chase_player(player.global_position)
	

func drop_artifact():
	Wwise.post_event_id(AK.EVENTS.VICTORY, self)
	$Artifact.visible = true
	$Artifact/CollisionShape2D.disabled = false

func _on_artifact_body_entered(body: Node2D) -> void:
	$Artifact.visible = false
	Inventory.forrest_artifact.visible = true
	player.knockback_timer = .25
	player.knockback_velocity = Vector2.ZERO
	player.get_node("HealthComponent").increase_current_health(15)
	
	await get_tree().create_timer(.1).timeout
	portal_open()

func portal_open():
	Global.teleport_banned = true
	$Portal.visible = true
	$Portal/CollisionShape2D.disabled = false
	$Portal/AnimatedSprite2D/AnimationPlayer.play("spin")
		
		
func _on_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		cam.limit_left = -10000000
		cam.limit_right = 10000000
		cam.limit_top = -10000000
		cam.limit_bottom = 10000000
		cam.zoom = Vector2(1,1)
		
		
		remove_child(body)
		Global.world_level = 2
		SceneTransitionManager.fade_to_scene("res://Map/Valhalla/home.tscn")

func pulse_thorns():
	while true:
		for thorn in $Hitbox.get_children():
			thorn.disabled = false
			await get_tree().create_timer(0.02).timeout  # "active" window
		for thorn in $Hitbox.get_children():
			thorn.disabled = true
			await get_tree().create_timer(0.02).timeout  # "inactive" window

func play_dialogue(path: String) -> void:
	modulate = Color.DIM_GRAY
	get_tree().paused = true
	var words = dialogue.load_dialogue(path)
	dialogue.get_node("AnimationPlayer").play("Jormungandr")
	dialogue.dialogue_begin(words)
	dialogue.connect("dialogue_finished", _on_dialogue_end)

func _on_dialogue_end():
	dialogue.get_node("AnimationPlayer").play("RESET")
	dialogue.disconnect("dialogue_finished", _on_dialogue_end)
	get_tree().paused = false
	modulate = Color.WHITE

	
	HUD.visible = true
	# Wait a moment for the player to be fully initialized
	await get_tree().create_timer(0.1).timeout
	# Connect the HUD to player
	HUD.connect_to_player()
	
	if snake != null:
		snake.get_node("CanvasLayer").visible = true
		await get_tree().create_timer(1).timeout
		snake.can_move = true
