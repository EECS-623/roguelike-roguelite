extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Wwise.register_game_obj(self, self.name)
	Wwise.register_listener(self)
	Wwise.load_bank_id(AK.BANKS.MUSIC)
	Wwise.post_event_id(AK.EVENTS.MUSIC, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/PatronSelection/patron_selection.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
