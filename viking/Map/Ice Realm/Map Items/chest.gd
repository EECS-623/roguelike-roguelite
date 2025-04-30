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
			update_key_visibility()
			$"../Sprite2D".play("open")
			Wwise.post_event_id(AK.EVENTS.KEY_ATTAIN, self)
			print("key acquired")
			print(Global.has_key)
			chestOpened = 1

func update_key_visibility():
	if Global.has_key == 1:
		Inventory.ice_key1.visible = true
	elif Global.has_key == 2:
		Inventory.ice_key2.visible = true
	elif Global.has_key == 3:
		Inventory.ice_key3.visible = true
