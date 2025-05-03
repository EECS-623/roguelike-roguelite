extends Node3D
@export var player: PackedScene = preload("res://Map/Valhalla/HouseScene/housePlayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_player = player.instantiate()
	
	add_child(my_player)
	my_player.global_position = Vector3(0, 2, 0)  # adjust as needed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
