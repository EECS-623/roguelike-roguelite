extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_mouse_entered() -> void:
	print("it entered!")
	get_tree().change_scene_to_file("res://Ice_Realm_2nd/ice_tileset.tscn")
	#if Input.is_action_just_pressed("left_click"):
		#get_tree().change_scene_to_file("res://earth_realm/earth_realm.tscn")
