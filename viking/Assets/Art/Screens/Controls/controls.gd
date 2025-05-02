extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	get_tree().change_scene_to_file("res://Game/MainMenu/main_menu.tscn")
