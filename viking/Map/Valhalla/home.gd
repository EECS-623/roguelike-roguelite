extends Area2D

@export var target_scene: String
func _ready():
	add_to_group("Portal")
func _on_body_entered(body):
	if body.is_in_group("player"):
		Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		get_parent().remove_child(body)
		if Global.world_level == 1:
			
			get_tree().call_deferred("change_scene_to_file", "res://Map/Forest Realm/earth_tileset.tscn")
			Global.world_level = 2
		elif Global.world_level == 2:
			get_tree().call_deferred("change_scene_to_file", "res://Map/Ice Realm/ice_tileset.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
