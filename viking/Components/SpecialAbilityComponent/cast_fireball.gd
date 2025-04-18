class_name CastFireball extends SpecialAbilityComponent

@onready var player : Player = $"../.."
var fireball = preload("res://Entities/Player/Fireball/fireball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cast_ability() -> void:
	if Global.patron_god == 1:
		var new_fireball = fireball.instantiate()
		Wwise.post_event_id(AK.EVENTS.FIREBALL, self)
		get_tree().current_scene.add_child(new_fireball)
		new_fireball.position = player.global_position
		new_fireball.direction = (player.get_global_mouse_position() - player.global_position).normalized()
		new_fireball.rotation = (player.get_global_mouse_position() - player.global_position).angle()
