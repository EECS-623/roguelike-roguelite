extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#$CollisionShape2D.set_deferred("disabled", true)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Combat Test/combat_test_map.tscn")
		print("hello")
