extends Area2D

@export var target_scene: String
func _ready():
	add_to_group("Tree")
func _on_body_entered(body):
	if body.is_in_group("Player"):
		#$CollisionShape2D.set_deferred("disabled", true)
		print("Victory!")
		if Global.relics == 3:
			get_tree().call_deferred("change_scene_to_file", "res://Game/Victory/victory.tscn")
