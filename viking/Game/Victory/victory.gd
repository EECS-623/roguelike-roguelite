extends Control


@export var scroll_speed: float = 100.0  # pixels per second

var start_y
var reset_y
var label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HUD.visible = false
	Inventory.visible = false
	label = $Label
	label.visible = false
	start_y = size.y
	reset_y = -label.size.y
	label.position.y = start_y
	await get_tree().create_timer(1).timeout
	$"VictoryLabel".visible = false
	label.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.position.y -= scroll_speed * delta

	if label.position.y <= reset_y:
		label.position.y = start_y

func _on_play_again_pressed() -> void:
	# Reset all stats and runes before starting a new game
	InventoryManager.reset_stats()
	
	# Reset other global values as needed
	Global.has_key = false
	Global.reset_globals()
	
	# Then change to the main scene
	get_tree().change_scene_to_file("res://Game/MainMenu/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
