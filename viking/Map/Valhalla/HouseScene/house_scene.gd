extends Node3D
@export var player: PackedScene = preload("res://Map/Valhalla/HouseScene/housePlayer.tscn")
@export var draugr: PackedScene = preload("res://Map/Valhalla/HouseScene/HouseSkeleton.tscn")
@export var tree: PackedScene = preload("res://Map/Valhalla/HouseScene/HouseTree.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_player = player.instantiate()
	
	add_child(my_player)
	my_player.global_position = Vector3(-10, 2, 10)  # adjust as needed
	
	var my_draugr
	var offsets = [Vector3(10,1,10), Vector3(20,1,10), Vector3(10,1,20), Vector3(30,1,10)]
	for offset in offsets:
		my_draugr = draugr.instantiate()
		add_child(my_draugr)
		my_draugr.global_position = offset  # adjust as needed
	
	var my_tree
	var tree_offsets = [Vector3(-40,1,40), Vector3(70,1,10), Vector3(-10,1,80), Vector3(30,1,30)]
	for offset in tree_offsets:
		my_tree = tree.instantiate()
		add_child(my_tree)
		my_tree.global_position = offset  # adjust as needed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
