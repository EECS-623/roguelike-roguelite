extends TileMapLayer
@export var enemy: PackedScene = preload("res://Entities/Enemies/Draugr/Basic Draugr/draugr.tscn")
@export var tree: PackedScene = preload("res://Map/Forest Realm/Map Items/tree.tscn")
@export var spike: PackedScene = preload("res://Map/Forest Realm/Map Items/spikes.tscn")
@export var grass: PackedScene = preload("res://Map/Forest Realm/Map Items/grass.tscn")
@export var chest: PackedScene = preload("res://Map/Forest Realm/Map Items/chest.tscn")
@export var appleTree: PackedScene = preload("res://Map/Forest Realm/Map Items/apples.tscn")
@export var apple: PackedScene = preload("res://Map/Forest Realm/Map Items/apple.tscn")


var leftmostEdge = -4
var rightmostEdge = 4
var upperEdge = -3
var lowerEdge = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.relics = 0
	Global.earth_enemies_left = 1000	
	#Wwise.set_state("LOCATION","MIDGARD")
	#Wwise.set_state("PLAYERLIFE","ALIVE")	
	Wwise.post_event_id(AK.EVENTS.MAP_LOADED, self)
	
	Wwise.post_event_id(AK.EVENTS.MIDGARD, self)
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
	set_cell(Vector2i(rightmostEdge-2, upperEdge), 0, Vector2i(1, 0))
	set_cell(Vector2i(rightmostEdge-2, upperEdge-1), 0, Vector2i(3, 0))
	

	#procedural generation setup
	var availableRooms = [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2),Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3)]


	#place starting glade items
	placedItems[totalItemsPlaced] = tree.instantiate()
	placedItems[totalItemsPlaced].position = Vector2(240, 240)
	add_child(placedItems[totalItemsPlaced])
	totalItemsPlaced += 1				
	
	#place starting glade items
	placedItems[totalItemsPlaced] = grass.instantiate()
	placedItems[totalItemsPlaced].position = Vector2(-205, 235)
	add_child(placedItems[totalItemsPlaced])
	totalItemsPlaced += 1				

	#place starting glade items
	placedItems[totalItemsPlaced] = grass.instantiate()
	placedItems[totalItemsPlaced].position = Vector2(255, -235)
	add_child(placedItems[totalItemsPlaced])
	totalItemsPlaced += 1		
	
	#place starting glade items
	placedItems[totalItemsPlaced] = grass.instantiate()
	placedItems[totalItemsPlaced].position = Vector2(-300, -150)
	add_child(placedItems[totalItemsPlaced])
	totalItemsPlaced += 1		

	#generate
	for i in range(leftmostEdge, rightmostEdge+1):
		for j in range(upperEdge, lowerEdge+1):
		
			if not (Vector2i(i, j) == Vector2i(rightmostEdge-2, upperEdge) || Vector2i(i, j) == Vector2i(leftmostEdge+1, upperEdge + 1 ) || Vector2i(i, j) == Vector2i(rightmostEdge, lowerEdge-1) || Vector2i(i, j) == Vector2i(1, lowerEdge/2+1)|| Vector2i(i, j) == Vector2i(leftmostEdge+1, lowerEdge) ||  Vector2i(i, j) == Vector2i(0,0)||  Vector2i(i, j) == Vector2i(0,-1)||  Vector2i(i, j) == Vector2i(-1, 0)||  Vector2i(i, j) == Vector2i(-1,-1)):
				#pick tile			
				var chosenTile = availableRooms.pick_random()
				#place tile

				print("Placing a tile")
				set_cell(Vector2i(i,j), 0, chosenTile)
				
				if( chosenTile == Vector2i(0, 2)):
					print("Placing a 0,2 tile")
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-158, 88)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(145, 218)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
								

					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-80, -100)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-15, -200)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
										
				
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-210, 190)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
					
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(166, -187)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
						
				
				elif( chosenTile == Vector2i(1, 2)):
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-174, 15)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(140, -100)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
									

					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(200, 150)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-80, -80)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
										

					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-177, -175)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
						
				
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(0, -197)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
					
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-150, 98)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
										

				
				elif( chosenTile == Vector2i(2, 2)):
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-155, 150)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position =Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(90, 97)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
							
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-80, -130)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
													
					
					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(180, 201)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
											

					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(190, -130)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
							
				
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(20, 200)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
					
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(120, 170)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
										
				elif( chosenTile == Vector2i(3, 2)):
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-100, 2)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position =Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(85, 8)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
																				
					
					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-125, 130)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
											

					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(19, 155)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
							
							
					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-5, -180)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1									
							
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-179, -34)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1										
		
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(169, 170)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
					
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(150, -150)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
					
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-170, 170)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
					
				elif( chosenTile == Vector2i(0, 3)):
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(154, 180)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position =Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(20, -50)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position =Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-110, -50)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1								
									
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(179, -90)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1										

					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-170, 193)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
					
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-80, 195)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1	
					
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-122, 120)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
					
								
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-10, 80)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
					
				elif( chosenTile == Vector2i(1, 3)):
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(180, 154)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-140, 48)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
					
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(75, -98)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1								
									

					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-20, 50)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-160, 174)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
										

					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-177, -175)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			

					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-5, 98)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1								
				
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(100, 25)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
					
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-125, -125)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
											
				elif( chosenTile == Vector2i(2, 3)):
					placedItems[totalItemsPlaced] = tree.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(157, 10)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
						
					

					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-165, -160)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
	
	
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-70, -130)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1							
					
					placedItems[totalItemsPlaced] = spike.instantiate()
					var offset = randf()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(20 + offset * 40, -100 + offset*20)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
										

					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(10, 80)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			

					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-145, 160)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1								
				
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-140, 0)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
					
				elif( chosenTile == Vector2i(3, 3)):
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-180, -170)
					add_child(placedItems[totalItemsPlaced])	
					totalItemsPlaced += 1			
						
					
					placedItems[totalItemsPlaced] = spike.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(20, 36)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			
										

					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(177, -175)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1			

					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(143, 170)
					add_child(placedItems[totalItemsPlaced])		
					totalItemsPlaced += 1								
				
					placedItems[totalItemsPlaced] = grass.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-150, 75)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1			
						
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(0, 150)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1																		
	
					placedItems[totalItemsPlaced] = enemy.instantiate()
					placedItems[totalItemsPlaced].position = Vector2((i+0.5)*480,(j+0.5)*480)+Vector2(-50, -50)
					add_child(placedItems[totalItemsPlaced])
					totalItemsPlaced += 1						
												
	#geneate special Tiles
	var availableSpecialRooms = [Vector2i(0, 0),  Vector2i(2, 0), Vector2i(0, 2)]
	var specialLocations = [Vector2i(leftmostEdge+1, upperEdge + 1 ), Vector2i(rightmostEdge, lowerEdge-1), Vector2i(1, lowerEdge/2+1), Vector2i(leftmostEdge+1, lowerEdge)]
	specialLocations.shuffle()
	#generate
	for position in specialLocations:
		
		if(availableSpecialRooms.size() > 0):
			#pick tile			
			var chosenTile = availableSpecialRooms.pick_random()
			availableSpecialRooms.erase(chosenTile)

			#place tile
			set_cell(position, 0, chosenTile)
			if (chosenTile == Vector2i(2,0)):
				placedItems[totalItemsPlaced] = chest.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(0, -100)
				add_child(placedItems[totalItemsPlaced])	
				totalItemsPlaced += 1	
				
				
				placedItems[totalItemsPlaced] = enemy.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(0, 0)
				add_child(placedItems[totalItemsPlaced])
				totalItemsPlaced += 1				
							
			if( chosenTile == Vector2i(0, 2)):
				print("Placing a 0,2 tile")
				placedItems[totalItemsPlaced] = tree.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-158, 88)
				add_child(placedItems[totalItemsPlaced])
				totalItemsPlaced += 1			
				
				placedItems[totalItemsPlaced] = tree.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(145, 218)
				add_child(placedItems[totalItemsPlaced])		
				totalItemsPlaced += 1			
							
				placedItems[totalItemsPlaced] = spike.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-80, -100)
				add_child(placedItems[totalItemsPlaced])	
				totalItemsPlaced += 1			
					
					
				placedItems[totalItemsPlaced] = grass.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-15, -200)
				add_child(placedItems[totalItemsPlaced])		
				totalItemsPlaced += 1			
									
				
				placedItems[totalItemsPlaced] = enemy.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-210, 190)
				add_child(placedItems[totalItemsPlaced])
				totalItemsPlaced += 1			
					
					
				placedItems[totalItemsPlaced] = enemy.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(166, -187)
				add_child(placedItems[totalItemsPlaced])	
				totalItemsPlaced += 1			
			if (chosenTile == Vector2i(0,0)):
				placedItems[totalItemsPlaced] = apple.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(-120, 150)
				add_child(placedItems[totalItemsPlaced])							
				totalItemsPlaced += 1			
				
				placedItems[totalItemsPlaced] = apple.instantiate()
				placedItems[totalItemsPlaced].position = map_to_local(position)+Vector2(140, 168)
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
			if(	Global.has_key == true):
				print("Start Teleport")
				#Wwise.post_event_id(AK.EVENTS.CHEST_OPEN, self)
				await get_tree().create_timer(1).timeout
				remove_child(body)
				get_tree().call_deferred("change_scene_to_file", "res://Entities/Bosses/Jormungandr/boss_arena.tscn")
			else:
				print("No key")
				

			
		await get_tree().create_timer(0.1).timeout
