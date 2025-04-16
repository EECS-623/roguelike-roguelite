extends Area2D

@onready var _collision_shape = $BlueCollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("it entered!")
			get_tree().change_scene_to_file("res://Map/Ice Realm/ice_tileset.tscn")

func _on_mouse_entered() -> void:
	pass
