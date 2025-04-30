extends Node2D
var chestOpened = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Sprite2D".play("closed")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass






func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if(chestOpened == 0):
			Global.has_key += 1
			$"../Sprite2D".play("open")
			print("key acquired")
			print(Global.has_key)
			chestOpened = 1
