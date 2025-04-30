extends TileMapLayer
@export var enemy: PackedScene = preload("res://Entities/Enemies/Draugr/Ice Draugr/ice_draugr.tscn")
@export var ranged: PackedScene = preload("res://Entities/Enemies/Volva/Ice Volva/ice_volva.tscn")

@export var chest: PackedScene = preload("res://Map/Ice Realm/Map Items/chest.tscn")
@export var apple: PackedScene = preload("res://Map/Ice Realm/Map Items/apple.tscn")

@export var odin: PackedScene = preload("res://Entities/NPCs/Odin/odin.tscn")
@export var classicWitch: PackedScene = preload("res://Entities/Enemies/Volva/Basic Volva/volva.tscn")
@export var classicEnemy: PackedScene = preload("res://Entities/Enemies/Draugr/Basic Draugr/draugr.tscn")

var leftmostEdge = -5
var rightmostEdge = 4
var upperEdge = -5
var lowerEdge = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.teleport_banned = false
	Global.upgrade_level = 2
	Global.relics = 0
	Global.earth_enemies_left = 1000		

	z_index = -2
	$Area2D.body_entered.connect(_on_body_entered)
	
	var placedItems = []
	placedItems.resize(10000)  
	var totalItemsPlaced = 0
	

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
			
		

	#set boss spawn
	var bossSpawn = floor (10* randf())
	set_cell(Vector2i(leftmostEdge+bossSpawn, upperEdge-1), 0, Vector2i(1,0))
	print("Placed a boss tile at ", leftmostEdge+bossSpawn)
	
	#procedural generation setup
	var availableRooms = [Vector2i(3, 2),  Vector2i(0, 2),Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3)]

	#generate
	for i in range(leftmostEdge, rightmostEdge+1):
		for j in range(upperEdge, lowerEdge+1):
		
			if not ( ((i == -3 || i == -2 || i==1 || i==2) && j >1) || Vector2i(i, j) == Vector2i(-5,lowerEdge)|| Vector2i(i, j) == Vector2i(-1,lowerEdge)|| Vector2i(i, j) == Vector2i(3,lowerEdge) ||Vector2i(i, j) == Vector2i(leftmostEdge, upperEdge+2 ) || Vector2i(i, j) == Vector2i(rightmostEdge-1, upperEdge+4  )|| Vector2i(i, j) == Vector2i((rightmostEdge+rightmostEdge+ leftmostEdge)/3, upperEdge+1) ):
				#pick tile			
				var chosenTile = availableRooms.pick_random()
				#place tile

				set_cell(Vector2i(i,j), 0, chosenTile)
				
				if(chosenTile == Vector2i(0, 2)):
					var variant =  randf()
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()
						
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(50, -50)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
				
				elif(chosenTile == Vector2i(3, 2)):
					var variant =  randf()					
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = ranged.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicWitch.instantiate()					

					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-177, -100)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
					
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()		
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(20, 150)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1						
					
				elif(chosenTile == Vector2i(0, 3)):
					var variant =  randf()										
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()							
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(100, -100)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
					
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()		
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-100, 100)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
					
				elif(chosenTile == Vector2i(1, 3)):
					var variant =  randf()															
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = ranged.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicWitch.instantiate()							
					placedItems[totalItemsPlaced] = ranged.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(20, -100)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
					
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()		
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(20, 150)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
					
				elif(chosenTile == Vector2i(2, 3)):

					var variant =  randf()															
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()							
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-50, -50)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
					
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()		
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-120, 150)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1								
					
				elif(chosenTile == Vector2i(3, 2)):
					var variant =  randf()															
					if(variant < 0.3):
						placedItems[totalItemsPlaced] = enemy.instantiate()
					else:
						placedItems[totalItemsPlaced] = classicEnemy.instantiate()							
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(0, 0)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
								
					
																				
				
	
	
	#create the verticle mountain range
	for i in range (3, lowerEdge+1):
		set_cell(Vector2i(-3, i), 0,Vector2i(0,1))
		set_cell(Vector2i(1, i), 0,Vector2i(0,1))
	for i in range (3, lowerEdge+1):
		set_cell(Vector2i(-2, i), 0,Vector2i(3,1))
		set_cell(Vector2i(2, i), 0,Vector2i(3,1))			
	#edges cases for verticle mountain range
	set_cell(Vector2i(-3,2), 0,Vector2i(2,2))
	set_cell(Vector2i(-2,2), 0,Vector2i(1,2))
	set_cell(Vector2i(1, 2), 0,Vector2i(2,2))
	set_cell(Vector2i(2, 2), 0,Vector2i(1,2))
		
	set_cell(Vector2i(-3, lowerEdge+1), 0,Vector2i(3,0))
	set_cell(Vector2i(-2, lowerEdge+1), 0,Vector2i(3,0))
	set_cell(Vector2i(1, lowerEdge+1), 0,Vector2i(3,0))
	set_cell(Vector2i(2, lowerEdge+1), 0,Vector2i(3,0))

	
								
	#geneate special Tiles
	var availableSpecialRooms = [Vector2i(0, 0),  Vector2i(0, 3), Vector2i(1, 2)]
	var specialLocations = [Vector2i(-5, lowerEdge ), Vector2i(-1, lowerEdge ), Vector2i(3, lowerEdge )]
	specialLocations.shuffle()
	#generate
	for position in specialLocations:
		
		#pick tile			
		var chosenTile = availableSpecialRooms.pick_random()
		availableSpecialRooms.erase(chosenTile)

		#place tile
		set_cell(position, 0, chosenTile)
		if (chosenTile == Vector2i(0,3)):
			placedItems[totalItemsPlaced] = chest.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-480, 100)
			add_child(placedItems[totalItemsPlaced])	
			totalItemsPlaced += 1	
			
			
			placedItems[totalItemsPlaced] = enemy.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-480, 200)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1				
			set_cell(position-Vector2i(1,0), 0, Vector2i(2,0))
			set_cell(position-Vector2i(1,-1), 0, Vector2i(2,1))
			
			
		elif (chosenTile == Vector2i(1,2)):			
			set_cell(position-Vector2i(1,0), 0, Vector2i(3,0))
			set_cell(position+Vector2i(0,1), 0, Vector2i(3,0))
			placedItems[totalItemsPlaced] = odin.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(0, 0)
			add_child(placedItems[totalItemsPlaced])	
			totalItemsPlaced += 1				
			
		elif (chosenTile == Vector2i(0,0)):			
			placedItems[totalItemsPlaced] = apple.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(100, 100)
			add_child(placedItems[totalItemsPlaced])	
			totalItemsPlaced += 1	
			
			
			placedItems[totalItemsPlaced] = apple.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-120, 150)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1		
			
						
	#geneate special Tiles
	var availableSpecialRooms2 = [Vector2i(0, 0),  Vector2i(1, 3), Vector2i(-1, -1)]
	var specialLocations2 = [Vector2i(leftmostEdge, upperEdge+2 ), Vector2i(rightmostEdge-1, upperEdge+4  ), Vector2i((rightmostEdge+rightmostEdge+ leftmostEdge)/3, upperEdge+1) ]
	specialLocations2.shuffle()
	#generate
	for position in specialLocations2:
		
		#pick tile			
		var chosenTile = availableSpecialRooms2.pick_random()
		availableSpecialRooms2.erase(chosenTile)

		#place tile
		if (chosenTile == Vector2i(1,3)):
			set_cell(position, 0, chosenTile)
			
			placedItems[totalItemsPlaced] = chest.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(25, -125)
			add_child(placedItems[totalItemsPlaced])	
			totalItemsPlaced += 1	
			
			
			placedItems[totalItemsPlaced] = enemy.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(0, 0)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1				

			
			
		elif (chosenTile == Vector2i(-1,-1)):			
			placedItems[totalItemsPlaced] = chest.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(0, 0)
			add_child(placedItems[totalItemsPlaced])	
			totalItemsPlaced += 1	
			
			placedItems[totalItemsPlaced] = enemy.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(100, 100)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1					
			
			placedItems[totalItemsPlaced] = ranged.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-100, 100)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1					
			
			placedItems[totalItemsPlaced] = classicEnemy.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-100, -100)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1					
			
			placedItems[totalItemsPlaced] = classicEnemy.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(100, -100)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1														
			
		elif (chosenTile == Vector2i(0,0)):		
			set_cell(position, 0, chosenTile)
				
			placedItems[totalItemsPlaced] = apple.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(100, 100)
			add_child(placedItems[totalItemsPlaced])	
			totalItemsPlaced += 1	
			
			
			placedItems[totalItemsPlaced] = apple.instantiate()
			placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-120, 150)
			add_child(placedItems[totalItemsPlaced])
			totalItemsPlaced += 1					
						
	# Called every frame. 'delta' is the elapsed time since the previous frame.
	#add the player
	#var my_player = player.instantiate()
	get_tree().current_scene.add_child(PlayerManager.player)
	PlayerManager.player.position = global_position

	
var locked = false
func _on_body_entered(body):
	if not body.is_in_group("player"):
		return
	while(true):
		#print("player entered")
#
		var cell = local_to_map(body.global_position)
		var tile_data = get_cell_tile_data(local_to_map(body.global_position))
		#if tile_data and tile_data.get_custom_data("pickupKey") and locked == false:
			#Global.relics = 1
#
			#print("Key aquired")
			#Wwise.post_event_id(AK.EVENTS.KEY_ATTAIN, self)
			#locked = true
			
		if tile_data and tile_data.get_custom_data("bossteleport"):
			if(	Global.has_key == 3):
				print("Start Teleport")
				Wwise.post_event_id(AK.EVENTS.CHEST_OPEN, self)
				await get_tree().create_timer(1).timeout
				remove_child(body)
				get_tree().call_deferred("change_scene_to_file", "res://Entities/Bosses/Ice_Golem/boss_arena.tscn")
			else:
				print("No key")
				
		if tile_data and tile_data.get_custom_data("ice"):
			print("You're on thin ice")
				
			
		await get_tree().create_timer(0.1).timeout
