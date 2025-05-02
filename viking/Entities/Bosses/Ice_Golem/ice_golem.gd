class_name IceGolem extends CharacterBody2D

#@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var ice_golem_state_machine : IceGolemStateMachine = $IceGolemStateMachine

var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
var state = "idle"
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")
	visible = true
	$CanvasLayer/HealthBarComponent.modulate =  Color.WHITE
	ice_golem_state_machine.ice_golem = self
	ice_golem_state_machine.player = player
	ice_golem_state_machine.initialize()
	Wwise.post_event_id(AK.EVENTS.ICE_BOSSGROAN, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func _on_health_component_death() -> void:
	Global.world_level = 3
	Wwise.post_event_id(AK.EVENTS.ICE_BOSSGROAN, self)
	queue_free()

func _on_health_component_t_damage(amount: float) -> void:
	if self and $HealthComponent.current_health > 0:
		for i in range(2):
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(.01).timeout
			$AnimatedSprite2D.modulate = Color.WHITE
			await get_tree().create_timer(.01).timeout
