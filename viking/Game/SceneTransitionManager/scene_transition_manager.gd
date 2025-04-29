extends Node

@onready var fade_rect: ColorRect = $FadeRect
var fade_time := 0.5  # Duration of fade in seconds

func _ready():
	# Make sure the ColorRect covers the entire screen
	fade_rect.scale = Vector2(1000,1000)
	#fade_rect.position = Vector2(0, 0)
	fade_rect.color.a = 0.0  # Start fully transparent
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Let clicks pass through
	fade_rect.z_index = 100  # Ensure it's on top of other nodes

func fade_to_scene(scene_path: String, player_position) -> void:
	fade_rect.position = player_position
	call_deferred("_fade_and_switch", scene_path)

func _fade_and_switch(scene_path: String) -> void:
	# Fade to black
	await _fade(0.0, 1.0)

	# Defer the scene change after the fade-out is complete
	get_tree().call_deferred("change_scene_to_file", scene_path)

	# Slight delay to ensure scene loads properly before fading in
	await get_tree().create_timer(0.1).timeout

	# Wait one frame for new scene to load, then fade in
	await get_tree().process_frame
	await _fade(1.0, 0.0)

func _fade(from_alpha: float, to_alpha: float) -> void:
	var t := 0.0
	while t < fade_time:
		t += get_process_delta_time()
		var alpha = lerp(from_alpha, to_alpha, t / fade_time)
		var color = fade_rect.color
		color.a = clamp(alpha, 0.0, 1.0)
		fade_rect.color = color
		await get_tree().process_frame
