extends Node3D
signal HouseKey
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/AnimatedSprite3D.play("closed")
	#add_to_group("open_chest")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("house_player"):
		$Area3D/AnimatedSprite3D.play("open")
		#remove_from_group("closed_chest")
		HouseKey.emit()
