class_name FreezeEffect extends StatusEffect

@export var slow_factor: float = 0.7

var target

func _process(delta: float):
	timer -= delta
	if timer <= 0:
		remove()
		queue_free()

func apply(_target):
	if _target and _target.has_method(""):
		target = _target

func remove():
	if target and target.has_method("modify_speed_multiplier"):
		target.modify_speed_multiplier(1.0)
