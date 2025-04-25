class_name StatusEffectManager extends Node

var effects := []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for effect in effects:
		effect.update(delta)
	
	effects = effects.filter(func(e): return e.timer > 0)

func apply_status_effect(effect: StatusEffect):
	
	for existing_effect in effects:
		if existing_effect.get_class() == effect.get_class():
			existing_effect.timer = effect.timer  # Refresh duration
			if effect.has_method("configure"):
				# takes the largest of two slow factors applied to the character
				existing_effect.configure(maxf(existing_effect.slow_factor, effect.slow_factor), effect.duration)
			existing_effect.apply(get_parent())  # Reapply to reset stats (e.g. speed)
			return  # Don’t add a new one
	add_child(effect)
	effect.apply(get_parent())
	effects.append(effect)
