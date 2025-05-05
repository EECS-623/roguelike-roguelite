extends Area3D

var unlock
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	unlock = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_house_snake_open_3d_portal() -> void:
	visible = true
	unlock = true



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("house_player") and unlock:
		SceneTransitionManager.fade_to_scene("res://Map/Valhalla/HouseScene/HouseIceMap/HouseIceScene.tscn")
