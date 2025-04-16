extends CharacterBody2D
@onready var _animated_sprite = $AnimatedSprite2D
#@export var player: PackedScene = preload("res://Player/player.tscn")
@onready var player = get_tree().root.get_node("Earth_tileset/Player") # Replace "Main/Player" with the actual path
 # Go up one level and find "Player"
@export var player_bullet: PackedScene = preload("res://Entities/Player/Magic_Bullet/Bullet.tscn")
@export var enemy_bullet: PackedScene = preload("res://Entities/Enemy_Bullet/enemy_bullet.tscn")
var SPEED : float = 300.0

@export var speed: float = 1

func _ready():
	SPEED = $SpeedComponent.get_speed()
	
func _process(_delta):
	
	if player != null: 
		
		var direction = (player.global_position - global_position).normalized()
		var current = "move_right"
		var up = "move_up"
		var down = "move_down"
		var velocity = Vector2.ZERO
		var in_aggro_range = false
		if player.global_position.distance_to(global_position) > 500:
			in_aggro_range = false
		else:
			in_aggro_range = true
			
		if not(in_aggro_range):
			velocity = Vector2.ZERO
			_animated_sprite.stop()
		elif direction.x < 0:
			_animated_sprite.flip_h = true
			velocity = direction * Global.enemy_speed
			_animated_sprite.play(current)
			
		elif direction.x > 0:
			_animated_sprite.flip_h = false
			velocity = direction * Global.enemy_speed
			_animated_sprite.play(current)
			
		elif direction.y <0:
			_animated_sprite.flip_h = false
			velocity = direction * Global.enemy_speed
			_animated_sprite.play(up)
			
		elif direction.y >0:
			_animated_sprite.flip_h = false
			velocity = direction * Global.enemy_speed
			_animated_sprite.play(down)
			
		else:
			velocity = Vector2.ZERO
			_animated_sprite.frame = 1
			_animated_sprite.stop()

		global_position += velocity
		var num = randi_range(1,300)
		if num < 4 and in_aggro_range:
			#shoot()
			pass
		

#func shoot():
	#var bullet = enemy_bullet.instantiate()
	#get_tree().current_scene.add_child(bullet)
	
	#bullet.position = global_position
	#bullet.direction = (player.global_position - global_position).normalized()

'''
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player_bullet")):
		queue_free()
		area.queue_free()
		Global.earth_enemies_left -= 1
		Global.mana += 1
		if Global.earth_enemies_left == 0:
			Global.relics += 1
			print("Relics: ")
			print(Global.relics)'''

func _on_health_component_death() -> void:
	queue_free()
