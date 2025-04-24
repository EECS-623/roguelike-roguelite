class_name StatusEffect extends Node

@export var duration: float
var timer : float = 0.0
var entity = null # the owner which the effect is applied to

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply(_target):
	entity = _target

func update(delta):
	timer -= delta
	if timer <= 0:
		queue_free()

func remove():
	queue_free()
