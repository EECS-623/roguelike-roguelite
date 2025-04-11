class_name IceGolem extends CharacterBody2D

#@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var ice_golem_state_machine : IceGolemStateMachine = $IceGolemStateMachine

var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
var state = "idle"
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ice_golem_state_machine.initialize(self, player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	#if (aggro_range.in_aggro):
		#direction = (aggro_range.player.global_position - global_position).normalized()
	#else:
		#direction = Vector2.ZERO
	##print(aggro_range.player)
	#global_position += velocity

#func set_direction() -> bool:
	#return true
#
func update_animation( state: String ) -> void:
	pass
	#animation_player.play( state + "_" + animation_direction())
#
#func animation_direction() -> String:
	#if cardinal_direction == Vector2.DOWN:
		#return "down"
	#elif cardinal_direction == Vector2.UP:
		#return "up"
	#elif cardinal_direction == Vector2.LEFT:
		#return "left"
	#else:
		#return "right"
#
#func _on_health_component_death() -> void:
	#Global.xp += 1
	#queue_free()
