extends CharacterBody3D #if you want physics-based movement

@export var speed: float = 1.0
@onready var player = get_parent().get_node("HousePlayer")
var gravity: int = 10
func _ready():
	pass
func _physics_process(delta):
	if not player:
		return

	# Get direction to player
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	
	# Move towards player
	velocity = direction * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	move_and_slide()
	# Face the camera or player (billboard effect)
	#look_at(player.global_transform.origin, Vector3.UP)

	



func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("bullet3D"):
		queue_free()
		body.queue_free()
