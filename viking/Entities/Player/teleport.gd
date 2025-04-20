extends Node
@onready var player : Player = $"../.."
# Called when the node enters the scene tree for the first time.
var upgrade_level = 1
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var teleport = true
var teleport_amount = 300
var teleport_begun = false

func _process(delta: float) -> void:
	var camera = $"../../Camera2D"
	if Input.is_action_just_pressed("right_click") and Global.patron_god == 3:
		if upgrade_level == 1:
			
			if teleport:
				
				var teleport_position = player.direction*teleport_amount
				var collision = player.move_and_collide(teleport_position, true)
				if not collision:
					teleport_begun = true
					camera.position_smoothing_enabled = true
					player.global_position += teleport_position
					teleport = false
					await get_tree().create_timer(3).timeout
					teleport = true
					teleport_begun = false
					camera.position_smoothing_speed = 18
					await get_tree().create_timer(2).timeout
					if not teleport_begun:
						camera.position_smoothing_enabled = false
					
		if upgrade_level == 2:
			pass	
					
					
					
					
					
					
					
					
				#print(camera.global_position.distance_to(camera.get_target_position()))
				#if camera.global_position.distance_to(camera.get_target_position()) < 1:
					#camera.position_smoothing_enabled = false
	#teleport anywhere script
	#if teleport:
		#position = get_global_mouse_position()
		#teleport = false
		#await get_tree().create_timer(3).timeout
		#teleport = true
		#this was the teleport where it took you anywhere
