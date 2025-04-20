class_name CastFireball extends SpecialAbilityComponent

@onready var player : Player = $"../.."
var fireball = preload("res://Entities/Player/Fireball/fireball.tscn")

var upgrade_level = 1 #From Will to Josh, this will be what will determine the special upgrade. Just connect a signal and a _on_signal_name_recieved to change it.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cast_ability() -> void:
	if Global.patron_god == 1:
		if upgrade_level == 1: #base lightning
			var new_fireball = fireball.instantiate()
			Wwise.post_event_id(AK.EVENTS.FIREBALL, self)
			get_tree().current_scene.add_child(new_fireball)
			new_fireball.position = player.global_position
			new_fireball.direction = (player.get_global_mouse_position() - player.global_position).normalized()
			new_fireball.rotation = (player.get_global_mouse_position() - player.global_position).angle()
		elif upgrade_level == 2: #three lightning shot.
			var new_fireball = fireball.instantiate()
			var mini_fireball_one = fireball.instantiate()
			var mini_fireball_two = fireball.instantiate()
			Wwise.post_event_id(AK.EVENTS.FIREBALL, self)
			get_tree().current_scene.add_child(new_fireball)
			get_tree().current_scene.add_child(mini_fireball_one)
			get_tree().current_scene.add_child(mini_fireball_two)
			var mouse_pos = player.get_global_mouse_position()
			var shoot_direction = (mouse_pos - player.global_position).normalized()
			var perpendicular = Vector2(-shoot_direction.y, shoot_direction.x)  # 90° rotated

			var spacing = 20

			# Main fireball (center)
			new_fireball.position = player.global_position
			new_fireball.direction = shoot_direction
			new_fireball.rotation = shoot_direction.angle()

			# Left mini fireball
			mini_fireball_one.position = player.global_position + perpendicular * spacing
			mini_fireball_one.scale = Vector2(0.5, 0.5)
			mini_fireball_one.direction = shoot_direction
			mini_fireball_one.rotation = shoot_direction.angle()

			# Right mini fireball
			mini_fireball_two.position = player.global_position - perpendicular * spacing
			mini_fireball_two.scale = Vector2(0.5, 0.5)
			mini_fireball_two.direction = shoot_direction
			mini_fireball_two.rotation = shoot_direction.angle()
		else: #lighnting beam
			var new_fireball = fireball.instantiate()
			var mini_fireball_one = fireball.instantiate()
			var mini_fireball_two = fireball.instantiate()
			var mini_fireball_three = fireball.instantiate()
			Wwise.post_event_id(AK.EVENTS.FIREBALL, self)
			get_tree().current_scene.add_child(new_fireball)
			get_tree().current_scene.add_child(mini_fireball_one)
			get_tree().current_scene.add_child(mini_fireball_two)
			var mouse_pos = player.get_global_mouse_position()
			var shoot_direction = (mouse_pos - player.global_position).normalized()

			# Main fireball (center)
			new_fireball.position = player.global_position
			new_fireball.direction = shoot_direction
			new_fireball.rotation = shoot_direction.angle()
			new_fireball.scale = Vector2(2, 2)

			#spawning multiple but will appear as one for more damage
			mini_fireball_one.position = player.global_position
			mini_fireball_one.scale = Vector2(2, 2)
			mini_fireball_one.direction = shoot_direction
			mini_fireball_one.rotation = shoot_direction.angle()

			mini_fireball_two.position = player.global_position
			mini_fireball_two.scale = Vector2(2, 2)
			mini_fireball_two.direction = shoot_direction
			mini_fireball_two.rotation = shoot_direction.angle()
			
			mini_fireball_three.position = player.global_position
			mini_fireball_three.scale = Vector2(2, 2)
			mini_fireball_three.direction = shoot_direction
			mini_fireball_three.rotation = shoot_direction.angle()
