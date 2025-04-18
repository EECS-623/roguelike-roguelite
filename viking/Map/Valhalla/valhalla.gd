extends TileMapLayer

@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if !PlayerManager.player:
		var my_player = player.instantiate()
		PlayerManager.player = my_player
	get_tree().current_scene.add_child(PlayerManager.player)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
