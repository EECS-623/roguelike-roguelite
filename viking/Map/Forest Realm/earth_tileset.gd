extends TileMapLayer
@export var enemy: PackedScene = preload("res://Entities/Enemies/Draugr/draugr.tscn")
var leftmostEdge = -4
var rightmostEdge = 4
var upperEdge = -3
var lowerEdge = 3

var haveKey = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)

	#var my_player = player.instantiate()
	get_tree().current_scene.add_child(PlayerManager.player)
	PlayerManager.player.position = global_position
	
	

	#create standard border
	#create top border
	for i in range (leftmostEdge, rightmostEdge+1):
		set_cell(Vector2i(i, upperEdge-1), 0,Vector2i(1, 1))
	#create bottom border
	for i in range (leftmostEdge , rightmostEdge+1):
		set_cell(Vector2i(i, lowerEdge+1), 0,Vector2i(2, 1))
		
	#create left border
	for i in range (upperEdge,lowerEdge+1 ):
		set_cell(Vector2i(leftmostEdge-1, i), 0,Vector2i(3, 1))		
	#create right border
	for i in range (upperEdge,lowerEdge +1):
		set_cell(Vector2i(rightmostEdge+1, i), 0,Vector2i(0, 1))				

	#create corners
	set_cell(Vector2i(leftmostEdge-1, upperEdge-1), 0,Vector2i(3, 0))
	set_cell(Vector2i(leftmostEdge-1, lowerEdge+1), 0,Vector2i(3, 0))
	set_cell(Vector2i(rightmostEdge+1, upperEdge-1), 0,Vector2i(3, 0))
	set_cell(Vector2i(rightmostEdge+1, lowerEdge+1), 0,Vector2i(3, 0))
	
	#create buffer borders
	#create top border
	for i in range (leftmostEdge-2, rightmostEdge+3):
		set_cell(Vector2i(i, upperEdge-2), 0,Vector2i(3,0))
	#create bottom border
	for i in range (leftmostEdge-2 , rightmostEdge+3):
		set_cell(Vector2i(i, lowerEdge+2), 0,Vector2i(3,0))
		
	#create left border
	for i in range (upperEdge-1,lowerEdge+2 ):
		set_cell(Vector2i(leftmostEdge-2, i), 0,Vector2i(3, 0))		
	#create right border
	for i in range (upperEdge-1,lowerEdge +2):
		set_cell(Vector2i(rightmostEdge+2, i), 0,Vector2i(3, 0))			
	


	#procedural generation setup
	var availableRooms = [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2),Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3)]

	#generate
	for i in range(leftmostEdge, rightmostEdge+1):
		for j in range(upperEdge, lowerEdge+1):
		
			#pick tile			
			var choseTile = availableRooms.pick_random()

			#place tile
			set_cell(Vector2i(i,j), 0, choseTile)

	#geneate special Tiles
	var availableSpecialRooms = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)]
	var specialLocations = [Vector2i(rightmostEdge-1, upperEdge), Vector2i(leftmostEdge+1, floor((upperEdge+lowerEdge)/2)), Vector2i(rightmostEdge, lowerEdge-1), Vector2i(1, 1)]
	specialLocations.shuffle()
	#generate
	for position in specialLocations:
		
		if(availableSpecialRooms.size() > 0):
			#pick tile			
			var choseTile = availableSpecialRooms.pick_random()
			availableSpecialRooms.erase(choseTile)

			#place tile
			set_cell(position, 0, choseTile)
			#generate enemeies
			var my_enemy = enemy.instantiate()
			my_enemy.position = map_to_local(position)+Vector2(400, 400)
			get_parent().add_child(my_enemy)
			Global.earth_enemies_left += 1			

	# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return
	while(true):
		#print("player entered")

		var cell = local_to_map(body.global_position)
		var tile_data = get_cell_tile_data(local_to_map(body.global_position))
		if tile_data and tile_data.get_custom_data("pickupKey"):
			haveKey = true
			print("Key aquired")
			
		if tile_data and tile_data.get_custom_data("bossteleport"):
			if(haveKey):
				print("Start Teleport")
				remove_child(body)
				get_tree().call_deferred("change_scene_to_file", "res://Entities/Bosses/Jormungandr/boss_arena.tscn")
			else:
				print("No key")
		await get_tree().create_timer(0.1).timeout
