extends Node3D
@export var player: PackedScene = preload("res://Map/Valhalla/HouseScene/housePlayer.tscn")
@export var draugr: PackedScene = preload("res://Map/Valhalla/HouseScene/HouseSkeleton.tscn")
@export var tree: PackedScene = preload("res://Map/Valhalla/HouseScene/HouseTree.tscn")
# Called when the node enters the scene tree for the first time.
var key_one = false
var key_two = false
var key_three = false

func _ready() -> void:
	pass
	#var my_player = player.instantiate()
	#
	#add_child(my_player)
	#my_player.global_position = Vector3(-10, 2, 10)  # adjust as needed
	#
	#var my_draugr
	#var offsets = [Vector3(10,1,10), Vector3(20,1,10), Vector3(10,1,20), Vector3(30,1,10)]
	#for offset in offsets:
		#my_draugr = draugr.instantiate()
		#add_child(my_draugr)
		#my_draugr.global_position = offset  # adjust as needed
	#
	#var my_tree
	#var tree_offsets = [Vector3(-40,1,40), Vector3(70,1,10), Vector3(-10,1,80), Vector3(30,1,30)]
	#for offset in tree_offsets:
		#my_tree = tree.instantiate()
		#add_child(my_tree)
		#my_tree.global_position = offset  # adjust as needed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_house_chest_house_key() -> void:
	if key_one:
		return
	key_one = true
	print("key collected")
	


func _on_house_chest_2_house_key() -> void:
	if key_two:
		return
	key_two = true
	print("key collected")

func _on_house_chest_3_house_key() -> void:
	if key_three:
		return
	key_three = true
	print("key collected")

func _on_house_boss_gate_enter_boss_gate() -> void:
	if key_one and key_two and key_three:
		SceneTransitionManager.fade_to_scene("res://Map/Valhalla/HouseScene/HouseIceMap/HouseIceBoss/HouseYetiArena.tscn")
