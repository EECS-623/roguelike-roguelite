class_name Clone extends State

@onready var move : State = $"../Move"

@export var s_projectile: PackedScene
@export var s_clone: PackedScene


var finished
var loki
var player

var delay = 10

var clones = []

var positions = [
	Vector2(-840, -150),
	Vector2(-800, 200),
	Vector2(-450, 500),
	Vector2(0, 600),
	Vector2(400, 500),
	Vector2(800, 200),
	Vector2(800, -200),
	Vector2(400, -450),
	Vector2(-400, -450),
	
]

func enter() -> void:
	delay = randf_range(2,4)
	finished = false
	loki.get_node("AnimationPlayer").play("teleport")
	await get_tree().create_timer(.5).timeout
	
	var actual_pos = randi_range(0, 6)
	loki.global_position = positions[actual_pos]
	loki.get_node("AnimationPlayer").play("RESET")

	
	for i in range(9):
		if i == actual_pos:
			continue
		
		var clone  = s_clone.instantiate()
		clone.player = player
		clone.delay = randf_range(2, 4)
		clone.global_position = positions[i]
		clones.append(clone)
		get_tree().current_scene.add_child(clone)



func state_process(delta : float) -> State:
	if finished:
		for clone in clones:
			if clone != null:
				clone.destroy()
		return move
	
	if delay <= 0:
		delay = randf_range(2,4)
		shoot_projectile()
	else:
		delay -= delta
	
	return null



func can_move_during():
	return false
	
func shoot_projectile():
	var direction_to_player = (player.global_position - loki.global_position).normalized()
	loki.update_animation("projectile", direction_to_player)
	await get_tree().create_timer(.5).timeout
	var projectile = s_projectile.instantiate()
	projectile.player = player
	var muzzle = loki.get_node("AnimatedSprite2D/Muzzle")
	projectile.global_position = muzzle.global_position
	get_tree().current_scene.add_child(projectile)
	await get_tree().create_timer(1).timeout
	


func _on_hurtbox_hurt(body: Variant) -> void:
	finished = true
