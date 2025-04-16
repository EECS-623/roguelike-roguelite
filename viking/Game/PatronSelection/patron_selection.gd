extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Map//Valhalla/home.tscn")
	Global.patron_god = 1


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Map//Valhalla/home.tscn")
	Global.patron_god = 2

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Map//Valhalla/home.tscn")
	Global.patron_god = 3
