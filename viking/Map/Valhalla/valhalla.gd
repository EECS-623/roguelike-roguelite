extends TileMapLayer

@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if !PlayerManager.player:
		var my_player = player.instantiate()
		PlayerManager.player = my_player
	get_tree().current_scene.add_child(PlayerManager.player)
	
  
	HUD.visible = true
	# Wait a moment for the player to be fully initialized
	await get_tree().create_timer(0.1).timeout
	# Connect the HUD to player
	HUD.connect_to_player()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
