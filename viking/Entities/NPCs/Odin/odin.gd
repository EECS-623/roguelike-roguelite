extends CharacterBody2D

var player_body: CharacterBody2D
@onready var button_prompt = $ButtonPrompt
var button_indicator: bool
var dialogue: DialogueUI
var dialogue_started: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_prompt.visible = false
	dialogue_started

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_body != null && Input.is_action_pressed("interact") && !dialogue_started:
		dialogue_started = true
		var dialogue_ui = player_body.get_node("DialogueUI")
		dialogue = dialogue_ui
		if get_tree().current_scene.name == "Home" and Global.world_level == 1:
			play_dialogue("res://Game/Dialogue/odin-valhalla-1.json")
		elif get_tree().current_scene.name == "Earth_tileset" and Global.has_key != 3:
			play_dialogue("res://Game/Dialogue/odin-midgard-1.json")
		elif get_tree().current_scene.name == "Earth_tileset" and Global.has_key == 3:
			play_dialogue("res://Game/Dialogue/odin-midgard-2.json")
		elif get_tree().current_scene.name == "Home" and Global.world_level == 2:
			play_dialogue("res://Game/Dialogue/odin-valhalla-1.json")
		elif get_tree().current_scene.name == "Ice_tileset" and Global.has_key != 3:
			play_dialogue("res://Game/Dialogue/odin-jotunheim-1.json")
		elif get_tree().current_scene.name == "Ice_tileset" and Global.has_key == 3:
			play_dialogue("res://Game/Dialogue/odin-jotunheim-2.json")

func _on_npc_interaction_area_player_entered(body: CharacterBody2D) -> void:
	player_body = body
	button_indicator = true
	button_prompt.visible = true
	var tween = create_tween()
	button_prompt.modulate.a = 0.0
	tween.tween_property(button_prompt, "modulate:a", 1.0, 0.3)

func _on_npc_interaction_area_player_exited(body: CharacterBody2D) -> void:
	player_body = null
	button_indicator = false
	var tween = create_tween()
	tween.tween_property(button_prompt, "modulate:a", 0.0, 0.3)
	#button_prompt.visible = false

func play_dialogue(path: String) -> void:
	get_tree().paused = true
	var words = dialogue.load_dialogue(path)
	dialogue.dialogue_begin(words)
	dialogue.connect("dialogue_finished", _on_dialogue_end)

func _on_dialogue_end():
	dialogue.disconnect("dialogue_finished", _on_dialogue_end)
	dialogue_started = false
	get_tree().paused = false
