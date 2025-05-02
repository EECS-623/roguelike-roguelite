extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get references to card areas
	var thor_card_area = $Thor/ThorCardArea
	var tyr_card_area = $Tyr/TyrCardArea
	var freya_card_area = $Freya/FreyaCardArea
	
	# Connect mouse enter/exit signals for Thor
	thor_card_area.mouse_entered.connect(func(): $ThorDescription.visible = true)
	thor_card_area.mouse_exited.connect(func(): $ThorDescription.visible = false)
	
	# Connect mouse enter/exit signals for Tyr
	tyr_card_area.mouse_entered.connect(func(): $TyrDescription.visible = true)
	tyr_card_area.mouse_exited.connect(func(): $TyrDescription.visible = false)
	
	# Connect mouse enter/exit signals for Freya
	freya_card_area.mouse_entered.connect(func(): $FreyaDescription.visible = true)
	freya_card_area.mouse_exited.connect(func(): $FreyaDescription.visible = false)
	
	# Ensure descriptions are hidden initially
	$ThorDescription.visible = false
	$TyrDescription.visible = false
	$FreyaDescription.visible = false

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
	# Tyr (Patron 2): Bonus to Max Health
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
