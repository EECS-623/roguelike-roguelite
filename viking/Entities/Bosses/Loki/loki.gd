class_name Loki extends CharacterBody2D

#@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var loki_state_machine : LokiStateMachine = $LokiStateMachine

var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/HealthBarComponent.modulate =  Color.WHITE
	loki_state_machine.loki = self
	loki_state_machine.player = player
	loki_state_machine.initialize()
	Wwise.post_event_id(AK.EVENTS.LOKI_LAUGH, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func _on_health_component_death() -> void:
	queue_free()

func update_animation(animation, direction = Vector2.DOWN):
	var animation_direction
	if abs(direction.x) > abs(direction.y):
		animation_direction = "right" if direction.x > 0 else "left"
	else:
		animation_direction = "down" if direction.y > 0 else "up"
	$AnimationPlayer.play(animation+"_"+animation_direction)
	
func _on_health_component_t_damage(amount: float) -> void:
	if self and $HealthComponent.current_health > 0:
		for i in range(2):
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(.01).timeout
			$AnimatedSprite2D.modulate = Color.WHITE
			await get_tree().create_timer(.01).timeout
