extends Control

@onready var easy_button = $Easy
@onready var medium_button = $Medium
@onready var unbeatable_button = $Unbeatable

var easy_normal: Texture
var easy_disabled: Texture
var medium_normal: Texture
var medium_disabled: Texture
var unbeatable_normal: Texture
var unbeatable_disabled: Texture

#Wwise Is Bank Loaded Checker
func load_bank_if_needed(bank_id: int) -> void:
	if not Global.loaded_banks.has(bank_id):
		var result = Wwise.load_bank_id(bank_id)
		if result:
			Global.loaded_banks[bank_id] = true
		else:
			print("Failed to load bank:", bank_id)
			
func _ready() -> void:
	Wwise.register_game_obj(self, self.name)
	Wwise.register_listener(self)
	#Wwise.load_bank_id(AK.BANKS.MUSIC_SFX)
	load_bank_if_needed(AK.BANKS.MUSIC_SFX)
	Wwise.post_event_id(AK.EVENTS.MAP_LOADED, self) #starts the whole Wwise Process of States.
	Wwise.post_event_id(AK.EVENTS.GAMEPLAY, self)
	if not Global.title_song_init:
		#print(Global.title_song_init)
		Wwise.post_event_id(AK.EVENTS.TITLE, self)
		Global.title_song_init = true
	
	# Load the difficulty button textures
	easy_normal = load("res://Assets/Art/Screens/Buttons/Easy Button.png")
	easy_disabled = load("res://Assets/Art/Screens/Buttons/Easy Button Disabled.png")
	medium_normal = load("res://Assets/Art/Screens/Buttons/Medium Button.png")
	medium_disabled = load("res://Assets/Art/Screens/Buttons/Medium Button Disabled.png")
	unbeatable_normal = load("res://Assets/Art/Screens/Buttons/Unbeatable Button.png")
	unbeatable_disabled = load("res://Assets/Art/Screens/Buttons/Unbeatable Button Disabled.png")
	
	# Connect the difficulty button signals
	easy_button.pressed.connect(_on_easy_pressed)
	medium_button.pressed.connect(_on_medium_pressed)
	unbeatable_button.pressed.connect(_on_unbeatable_pressed)
	
	# Update the button appearances based on current difficulty
	update_difficulty_buttons()
	print("difficulty level is currently ", Global.difficulty_level)

# Update all difficulty buttons to show the current selection
func update_difficulty_buttons() -> void:
	# Set all buttons to their default state
	easy_button.texture_normal = easy_normal if Global.difficulty_level != "easy" else easy_disabled
	medium_button.texture_normal = medium_normal if Global.difficulty_level != "medium" else medium_disabled
	unbeatable_button.texture_normal = unbeatable_normal if Global.difficulty_level != "unbeatable" else unbeatable_disabled

func _on_easy_pressed() -> void:
	Global.difficulty_level = "easy"
	print("difficulty level set to ", Global.difficulty_level)
	Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	update_difficulty_buttons()

func _on_medium_pressed() -> void:
	Global.difficulty_level = "medium"
	print("difficulty level set to ", Global.difficulty_level)
	Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	update_difficulty_buttons()

func _on_unbeatable_pressed() -> void:
	Global.difficulty_level = "unbeatable"
	print("difficulty level set to ", Global.difficulty_level)
	Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	update_difficulty_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	get_tree().change_scene_to_file("res://Game/PatronSelection/patron_selection.tscn")

func _on_quit_pressed() -> void:
	Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	get_tree().quit()

func _on_controls_pressed() -> void:
	Wwise.post_event_id(AK.EVENTS.NEXT_DIALOUGE, self)
	get_tree().change_scene_to_file("res://Assets/Art/Screens/Controls/Controls.tscn")
