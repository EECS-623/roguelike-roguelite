extends Control


# Called when the node enters the scene tree for the first time.

#Wwise Is Bank Loaded Checker
func load_bank_if_needed(bank_id: int) -> void:
	if not Global.loaded_banks.has(bank_id):
		var result = Wwise.load_bank_id(bank_id)
		if result:
			Global.loaded_banks[bank_id] = true
		else:
			print("Failed to load bank:", bank_id)
			
func _ready() -> void:
	Wwise.register_game_obj(self, self.name)
	Wwise.register_listener(self)
	load_bank_if_needed(AK.BANKS.MUSIC_SFX)
	#Wwise.load_bank_id(AK.BANKS.MUSIC_SFX)
	
	#Wwise.post_event_id(AK.EVENTS.MUSIC, self)
	#await get_tree().create_timer(1).timeout
	#Wwise.post_event_id(AK.EVENTS.SWORD_ATTACK_PC, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/PatronSelection/patron_selection.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
