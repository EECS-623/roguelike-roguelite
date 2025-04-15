extends Node
@onready var player : Player = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var teleport = true
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right_click") and Global.patron_god == 3:
		if teleport:
			player.global_position += player.direction*300
			teleport = false
			await get_tree().create_timer(3).timeout
			teleport = true
	#teleport anywhere script
	#if teleport:
		#position = get_global_mouse_position()
		#teleport = false
		#await get_tree().create_timer(3).timeout
		#teleport = true
		#this was the teleport where it took you anywhere
