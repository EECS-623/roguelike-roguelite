extends TileMapLayer
@export var enemy: PackedScene = preload("res://Ice_Realm_2nd/ice_enemy.tscn")
@export var player: PackedScene = preload("res://Player/player.tscn")
var altitude = FastNoiseLite.new()
var width = 300
var height = 300
var enemy_count = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_player = player.instantiate()
	get_tree().current_scene.add_child(my_player)
	my_player.position = global_position
	
	
	altitude.seed = randi()
	altitude.frequency = 0.01
	for i in range(width):
		for j in range(height):
			var alt = altitude.get_noise_2d(0.0-(width/ 2.0)+i, 0.0-(height/2.0)+j)
			
			if alt < 0:
				set_cell(Vector2i(int(0.0-(width/2.0)+i), int(0.0-(height/2.0)+j)),0,Vector2i(0,0))
				var num = randi_range(0,10000)
				if num < 3:
					var my_enemy = enemy.instantiate()
					my_enemy.position = Vector2(0-(width/2.0)+i*4, 0-(height/2.0)+j*4)
					get_parent().add_child(my_enemy)
					enemy_count += 1
					print("enemy_added")
	
					
					
			else:
				set_cell(Vector2i(int(0-(width/2.0)+i), int(0-(height/2.0)+j)),0,Vector2i(1,0))
# Called every frame. 'delta' is the elapsed time since the previous frame.

				
