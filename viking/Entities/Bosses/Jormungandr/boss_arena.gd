extends Node2D
@export var s_player: PackedScene = preload("res://Entities/Player/player.tscn")
@export var s_snake: PackedScene 

var player = Node2D
var snake = Node2D
var snake_dead = false
var dialogue: DialogueUI
var cam
var first_dialogue = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	player = PlayerManager.player

	
	get_tree().current_scene.add_child(player)
	player.position = Vector2(400,400)
	if player == null:
		player = s_player.instantiate()
	
	snake = s_snake.instantiate()
	get_tree().current_scene.add_child(snake)
	snake.get_node("CanvasLayer").visible = false

	
	var dialogue_ui = player.get_node("DialogueUI")
	dialogue = dialogue_ui
	play_dialogue("res://Game/Dialogue/jormungandr-1.json")
	

	
	pulse_thorns()
	
	cam = player.get_node("Camera2D")
	cam.limit_left = -877
	cam.limit_right = 924
	cam.limit_top = -897
	cam.limit_bottom = 900
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if snake == null and not snake_dead:
		snake_dead = true
		Wwise.post_event_id(AK.EVENTS.BOSS_DEATH, self)
		play_dialogue("res://Game/Dialogue/jormungandr-2.json")
		portal_open()
	elif snake != null:
		snake.chase_player(player.global_position)
	
	print(player.get_node("Hurtbox").health_component.current_health)

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
		remove_child(body)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/home.tscn")

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
	dialogue.dialogue_begin(words)
	dialogue.connect("dialogue_finished", _on_dialogue_end)

func _on_dialogue_end():
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

	
