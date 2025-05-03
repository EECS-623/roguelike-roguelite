extends Node2D
@export var s_player: PackedScene = preload("res://Entities/Player/player.tscn")
@export var s_loki: PackedScene 

var player = Node2D
var loki = Node2D
var loki_dead = false
var dialogue: DialogueUI
var cam
var real_odin = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Wwise.post_event_id(AK.EVENTS.BOSS, self)
	Global.teleport_banned = false
	player = PlayerManager.player
	if player == null:
		Global.patron_god = 3
		player = s_player.instantiate()
	
	get_tree().current_scene.add_child(player)
	
	
	
	player.position = Vector2(0,400)
	loki = s_loki.instantiate()
	loki.player = player
	get_tree().current_scene.add_child(loki)
	
	
	loki.get_node("CanvasLayer").visible = false
	HUD.visible = false
	# Wait a moment for the player to be fully initialized
	await get_tree().create_timer(0.1).timeout
	# Connect the HUD to player
	HUD.connect_to_player()
	
	var dialogue_ui = player.get_node("DialogueUI")
	dialogue = dialogue_ui
	play_dialogue("res://Game/Dialogue/loki-2.json")
	Wwise.post_event_id(AK.EVENTS.BOSS, self)
	cam = player.get_node("Camera2D")
	cam.limit_left = -1048
	cam.limit_right = 1048
	cam.limit_top = -1048
	cam.limit_bottom = 1048
	cam.zoom =  Vector2(.75, .75)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if loki == null and not loki_dead:
		loki_dead = true
		play_dialogue("res://Game/Dialogue/loki-3.json")
		Wwise.post_event_id(AK.EVENTS.VICTORY, self)
	pass
	

func play_dialogue(path: String) -> void:
	modulate = Color.DIM_GRAY
	get_tree().paused = true
	var words = dialogue.load_dialogue(path)
	dialogue.get_node("AnimationPlayer").play("Loki")
	dialogue.dialogue_begin(words)
	dialogue.connect("dialogue_finished", _on_dialogue_end)

func _on_dialogue_end():
	if loki_dead:
		real_odin = true
		#play_dialogue("res://Game/Dialogue/real_odin.json")
	
	if real_odin:
		get_tree().call_deferred("change_scene_to_file", "res://Game/Victory/victory.tscn")

	
	dialogue.get_node("AnimationPlayer").play("RESET")
	dialogue.disconnect("dialogue_finished", _on_dialogue_end)
	get_tree().paused = false
	modulate = Color.WHITE

	
	HUD.visible = true
	# Wait a moment for the player to be fully initialized
	await get_tree().create_timer(0.1).timeout
	# Connect the HUD to player
	HUD.connect_to_player()

	
	if loki != null:
		loki.get_node("CanvasLayer").visible = true
		await get_tree().create_timer(1).timeout
	
