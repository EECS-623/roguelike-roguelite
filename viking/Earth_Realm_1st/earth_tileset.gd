extends TileMapLayer
@export var enemy: PackedScene = preload("res://Enemy/enemy.tscn")
@export var player: PackedScene = preload("res://Player/player.tscn")
var altitude = FastNoiseLite.new()
var width = 300
var height = 300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_player = player.instantiate()
	get_tree().current_scene.add_child(my_player)
	my_player.position = global_position
	
	
	altitude.seed = randi()
	altitude.frequency = 0.008
	for i in range(50):
		for j in range(50):
			set_cell(Vector2i(int(0.0-(width/2.0)+i), int(0.0-(height/2.0)+j)),0,Vector2i(0,0))
	for i in range(50,width):
		for j in range(50,height):
			var alt = altitude.get_noise_2d(0.0-(width/ 2.0)+i, 0.0-(height/2.0)+j)

			if alt > 0:
				set_cell(Vector2i(int(0.0-(width/2.0)+i), int(0.0-(height/2.0)+j)),0,Vector2i(0,0))
				var num = randi_range(0,10000)
				if num < 3:
					var my_enemy = enemy.instantiate()
					my_enemy.position = Vector2(0-(width/2.0)+i*6, 0-(height/2.0)+j*6)
					get_parent().add_child(my_enemy)
					Global.earth_enemies_left += 1
					#print("enemy_added")
	
			#elif alt < 0 and alt > -.05:
				#set_cell(Vector2i(int(0.0-(width/2.0)+i), int(0.0-(height/2.0)+j)),1,Vector2i(0,0))
			else:
				set_cell(Vector2i(int(0-(width/2.0)+i), int(0-(height/2.0)+j)),0,Vector2i(1,0))
# Called every frame. 'delta' is the elapsed time since the previous frame.

				
