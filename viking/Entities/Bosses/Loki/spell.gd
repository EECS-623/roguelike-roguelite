extends Node2D

var loki
var orbit_radius = 300.0
var start_angle
var start_anim
var timer = 5

func _ready():
	$AnimationPlayer.play("growtate")
	$AnimationPlayer.seek(start_anim, true)


func _physics_process(delta):
	if timer <=0:
		queue_free()
	else:
		start_angle += delta
		global_position = loki.global_position + Vector2(cos(start_angle), sin(start_angle)) * orbit_radius
		timer -= delta
	
	
