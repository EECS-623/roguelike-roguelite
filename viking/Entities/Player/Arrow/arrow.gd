class_name Arrow extends Area2D
var direction: Vector2

# Called when the node enters the scene tree for the first time.
var cursor_position
var rotation_angle
var has_pierced_once : bool
var pierced_enemy_ids := {}

func _ready() -> void:
	#add_to_group("player")
	##direction = direction.normalized()
	has_pierced_once = false
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 2.0
	timer.connect("timeout", _on_timer_timeout)
	timer.start()
	Wwise.post_event_id(AK.EVENTS.FIREBALL, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * Global.bullet_speed * delta

func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	
func _on_hitbox_hit(body: Variant) -> void:
	if body.get_parent().is_in_group("enemy"):
		if body.get_instance_id() in pierced_enemy_ids:
			return  # Already hit this one
		pierced_enemy_ids[body.get_instance_id()] = true
		if not has_pierced_once:
			has_pierced_once = true
			set_deferred("monitoring", false)
			await get_tree().create_timer(0.05).timeout
			monitoring = true
		else:
			print("reached here")
			queue_free()
	else:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()  
