extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Area2D")
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#$CollisionShape2D.set_deferred("disabled", true)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Forest Realm/Boss/boss_arena.tscn")
		print("hello")
