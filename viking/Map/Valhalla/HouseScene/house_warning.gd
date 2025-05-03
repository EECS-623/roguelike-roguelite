extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_back_to_valhalla_pressed() -> void:
	get_tree().current_scene.add_child(PlayerManager.player)
	PlayerManager.player.global_position = Vector2(110,0)
	SceneTransitionManager.fade_to_scene("res://Map/Valhalla/home.tscn")


func _on_tohouse_pressed() -> void:
	SceneTransitionManager.fade_to_scene("res://Map/Valhalla/HouseScene/HouseScene.tscn")
