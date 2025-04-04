extends Area2D
@onready var _animated_sprite = $AnimatedSprite2D
#@export var player: PackedScene = preload("res://Player/player.tscn")
@onready var player = get_tree().root.get_node("Lava_tileset/Player") # Replace "Main/Player" with the actual path
 # Go up one level and find "Player"
@export var player_bullet: PackedScene = preload("res://Magic_Bullet/Bullet.tscn")
@export var enemy_bullet: PackedScene = preload("res://Enemy_Bullet/enemy_bullet.tscn")
@export var SPEED : float = 300.0

@export var speed: float = 1
func _ready():
	pass
func _process(_delta):
	if player != null: 
		
		var direction = (player.global_position - global_position).normalized()
		if direction.x < 0:
			_animated_sprite.flip_h = true
		elif direction.x > 0:
			_animated_sprite.flip_h = false
		if direction:
			_animated_sprite.play("run")
			var velocity = direction * speed
			global_position += velocity
		else:
			_animated_sprite.stop()
		
		var num = randi_range(1,1000)
		if num < 4:
			shoot()
		

func shoot():
	var bullet = enemy_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.position = global_position
	bullet.direction = (player.global_position - global_position).normalized()
	

func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player_bullet")):
		Global.lava_enemies_left -= 1
		if Global.lava_enemies_left == 0:
			Global.relics += 1
			print("Relics: ")
			print(Global.relics)
		queue_free()
		area.queue_free()
