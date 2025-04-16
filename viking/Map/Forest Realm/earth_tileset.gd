extends TileMapLayer
@export var enemy: PackedScene = preload("res://Entities/Enemies/Draugr/draugr.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var my_player = player.instantiate()
	get_tree().current_scene.add_child(PlayerManager.player)
	PlayerManager.player.position = global_position
	
	#create top border
	for i in range (-4, 5):
		set_cell(Vector2i(i, -3), 0,Vector2i(0, 3))
	#create bottom border
	for i in range (-4, 5):
		set_cell(Vector2i(i, 4), 0,Vector2i(0, 3))
		
	#create left border
	for i in range (-2, 4):
		set_cell(Vector2i(-4, i), 0,Vector2i(0, 3))		
	#create right border
	for i in range (-2, 4):
		set_cell(Vector2i(4, i), 0,Vector2i(0, 3))				

	#-2 row
	set_cell(Vector2i(-3, -2), 0,Vector2i(0, 3))
	set_cell(Vector2i(-2, -2), 0,Vector2i(1, 3))
	set_cell(Vector2i(-1, -2), 0,Vector2i(3, 0))
	set_cell(Vector2i(0, -2), 0,Vector2i(0, 3))
	set_cell(Vector2i(1, -2), 0,Vector2i(0, 3))
	set_cell(Vector2i(2, -2), 0,Vector2i(0, 3))
	set_cell(Vector2i(3, -2), 0,Vector2i(0, 3))


	#-1 row
	set_cell(Vector2i(-3, -1), 0,Vector2i(3, 0))
	set_cell(Vector2i(-2, -1), 0,Vector2i(2, 2))
	set_cell(Vector2i(-1, -1), 0,Vector2i(2, 3))
	set_cell(Vector2i(0, -1), 0,Vector2i(3, 2))
	set_cell(Vector2i(1, -1), 0,Vector2i(2, 2))
	set_cell(Vector2i(2, -1), 0,Vector2i(2, 0))
	set_cell(Vector2i(3, -1), 0,Vector2i(3, 0))
	
	#0 row
	set_cell(Vector2i(-3, 0), 0,Vector2i(0, 0))
	set_cell(Vector2i(-2, 0), 0,Vector2i(2, 3))
	set_cell(Vector2i(1, 0), 0,Vector2i(2, 3))
	set_cell(Vector2i(2, 0), 0,Vector2i(1, 0))
	set_cell(Vector2i(3, 0), 0,Vector2i(1, 2))
	
	#1 row
	set_cell(Vector2i(-3, 1), 0,Vector2i(0, 2))
	set_cell(Vector2i(-2, 1), 0,Vector2i(0, 0))
	set_cell(Vector2i(0, 1), 0,Vector2i(1, 0))
	set_cell(Vector2i(1, 1), 0,Vector2i(1, 2))
	set_cell(Vector2i(2, 1), 0,Vector2i(0, 3))
	set_cell(Vector2i(3, 1), 0,Vector2i(0, 3))	
	
	#2 row
	set_cell(Vector2i(-3, 2), 0,Vector2i(0,3))
	set_cell(Vector2i(-2, 2), 0,Vector2i(0, 2))
	set_cell(Vector2i(-1, 2), 0,Vector2i(2, 3))
	set_cell(Vector2i(0, 2), 0,Vector2i(1, 2))
	set_cell(Vector2i(1, 2), 0,Vector2i(0, 3))
	set_cell(Vector2i(2, 2), 0,Vector2i(0, 3))
	set_cell(Vector2i(3, 2), 0,Vector2i(0, 3))	

	#3 row
	set_cell(Vector2i(-3, 3), 0,Vector2i(0,3))
	set_cell(Vector2i(-2, 3), 0,Vector2i(0, 0))
	set_cell(Vector2i(-1, 3), 0,Vector2i(2, 3))
	set_cell(Vector2i(0, 3), 0,Vector2i(1, 0))
	set_cell(Vector2i(1, 3), 0,Vector2i(0, 3))
	set_cell(Vector2i(2, 3), 0,Vector2i(0, 3))
	set_cell(Vector2i(3, 3), 0,Vector2i(0, 3))		
	
	#procedural generation setup
	var availableRooms = [Vector2i(2, 3), Vector2i(2, 3), Vector2i(3, 3)]
	var availablePositions = [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(-1, 1)]

	#generate
	for position in availablePositions:
		#pick tile
		print(position)
		
		var choseTile = availableRooms.pick_random()
		print(choseTile)
		#don'st pick same tile again
		availableRooms.erase(choseTile)
		#place tile
		set_cell(position, 0, choseTile)
		#generate enemeies
		var my_enemy = enemy.instantiate()
		my_enemy.position = map_to_local(position+ Vector2i(1, 0))
		get_parent().add_child(my_enemy)
		Global.earth_enemies_left += 1		
		


	
# Called every frame. 'delta' is the elapsed time since the previous frame.

				
