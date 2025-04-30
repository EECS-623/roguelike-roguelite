extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	# Thor (Patron 1): Bonus to Melee Damage
	Global.patron_god = 1
	#Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	#get_tree().change_scene_to_file("res://Map//Valhalla/home.tscn")
	SceneTransitionManager.fade_to_scene("res://Map//Valhalla/home.tscn")

func _on_button_2_pressed() -> void:
	# Tyr (Patron 2): Bonus to Max Health. This bonus is handled in home.gd since player is instantiated in Home.tscn
	Global.patron_god = 2
	#Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	#get_tree().change_scene_to_file("res://Map//Valhalla/home.tscn")
	SceneTransitionManager.fade_to_scene("res://Map//Valhalla/home.tscn")

func _on_button_3_pressed() -> void:
	# Freya (Patron 3): Bonus to Speed
	Global.patron_god = 3
	#Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	#get_tree().change_scene_to_file("res://Map//Valhalla/home.tscn")
	SceneTransitionManager.fade_to_scene("res://Map//Valhalla/home.tscn")
