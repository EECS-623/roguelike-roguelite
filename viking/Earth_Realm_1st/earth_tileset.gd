extends TileMapLayer

var altitude = FastNoiseLite.new()
var width = 300
var height = 300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	altitude.seed = randi()
	altitude.frequency = 0.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	for i in range(width):
		for j in range(height):
			var alt = altitude.get_noise_2d(0-(width/2)+i, 0-(height/2)+j)
			
			if alt < 0:
				set_cell(Vector2i(0-(width/2)+i, 0-(height/2)+j),0,Vector2i(0,0))
			else:
				set_cell(Vector2i(0-(width/2)+i, 0-(height/2)+j),0,Vector2i(1,0))
				
