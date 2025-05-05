extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Wwise.post_event_id(AK.EVENTS.DEAD, self)
	HUD.visible = false
	Inventory.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_again_pressed() -> void:
	# Reset all stats and runes before starting a new game
	Wwise.post_event_id(AK.EVENTS.DEAD, self)
	await get_tree().create_timer(.5).timeout
	InventoryManager.reset_stats()
	Global.reset_globals()
	# Reset other global values as needed
	Global.has_key = false
	# Then change to the main scene
	get_tree().change_scene_to_file("res://Game/MainMenu/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
