extends Control

func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/PatronSelection/patron_selection.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
