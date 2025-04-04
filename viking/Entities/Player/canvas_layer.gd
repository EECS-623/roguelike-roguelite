extends CanvasLayer

signal increase_speed

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Relics.text = "Relics: %s" % Global.relics
	$XP.text = "XP: %s" % Global.xp



func _on_speed_pressed() -> void:
	if Global.xp > 0:
		Global.xp -= 1
		increase_speed.emit()
		#Global.player_speed += 30


func _on_bullet_speed_pressed() -> void:
	if Global.xp > 0:
			Global.xp -= 1
			#Global.bullet_speed += 30


func _on_health_pressed() -> void:
	if Global.xp > 0:
			Global.xp -= 1
			#Global.player_health += 20
