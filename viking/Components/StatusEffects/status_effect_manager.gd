class_name StatusEffectManager extends Node

var effects := []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for effect in effects:
		effect.update(delta)
	
	effects = effects.filter(func(e): return e.timer > 0)

func apply_status_effect(effect: StatusEffect):
	add_child(effect)
	effect.apply(get_parent())
	effects.append(effect)
