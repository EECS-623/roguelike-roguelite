extends Area2D

@onready var pickup_range = $PickupRange
@onready var timer = $Timer

var pickup_speed = 200.0
var pickup_delay = 0.3
var can_follow : bool
var in_range : bool
var drop_from_done : bool
var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_follow = false
	timer.start(pickup_delay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_follow and in_range and drop_from_done:
		var destination = player.global_position
		var dir = (destination - global_position).normalized()
		var movement = dir * pickup_speed * delta
		
		if global_position.distance_to(destination) > pickup_speed * delta:
			global_position += movement
		else:
			global_position = destination 
		
		#alternative speed calculation:
		#global_position = global_position.move_toward(player.global_position, speed * delta)

func drop_from(origin_position: Vector2):
	global_position = origin_position

	var drop_radius = 80.0
	var offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randf_range(drop_radius / 2.0, drop_radius)
	var target_position = global_position + offset
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	drop_from_done = true

func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		in_range = true

func _on_body_entered(body: Node2D) -> void:
	Global.xp += 1
	queue_free()

func _on_timer_timeout() -> void:
	can_follow = true
