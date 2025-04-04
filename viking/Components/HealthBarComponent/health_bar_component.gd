class_name HealthBarComponent extends ProgressBar

@export var health_component : HealthComponent
@export var health_bar_progress : HealthBarProgress
@export var reset_visibility_timer : ResetVisibilityTimer

var change_value_tween: Tween
var opacity_tween : Tween 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if health_component:
		health_component.t_damage.connect(change_value)
		health_component.i_current_health.connect(change_value)
		health_component.i_max_health.connect(_update_max_health_bar)
		_setup_health_bar(health_component.get_max_health())
	if reset_visibility_timer:
		reset_visibility_timer.timeout.connect(_on_reset_visibility_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _setup_health_bar( max_val: float ):
	modulate.a = 0.0
	value = max_val
	max_value = max_val
	health_bar_progress.value = max_val
	health_bar_progress.max_value = max_val

func _update_max_health_bar (val : float):
	max_value = val
	health_bar_progress.max_value = val

func change_value(new_value: float):
	_change_opacity(1.0)
	
	value = new_value
	
	if change_value_tween:
		change_value_tween.kill()
		
	change_value_tween = create_tween()
	if reset_visibility_timer:
		change_value_tween.finished.connect(reset_visibility_timer.start)
	change_value_tween.tween_property(health_bar_progress, "value", new_value, 0.35).set_trans(Tween.TRANS_SINE)

func _change_opacity(new_amount: float):
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a", new_amount, 0.12).set_trans(Tween.TRANS_SINE)

func _on_reset_visibility_timeout() -> void:
	_change_opacity(0.0)
