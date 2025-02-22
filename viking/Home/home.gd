extends Area2D

@export var target_scene: String
func _ready():
	add_to_group("Portal")
func _on_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://Map/map.tscn")
		print("hello")
