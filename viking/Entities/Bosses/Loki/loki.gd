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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func _on_health_component_death() -> void:
	queue_free()
