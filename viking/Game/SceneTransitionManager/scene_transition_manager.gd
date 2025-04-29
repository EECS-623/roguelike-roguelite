extends CanvasLayer

func fade_to_scene(target: String) -> void:
	$TextureRect.visible = true
	#$AnimationPlayer.play('appear')
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().call_deferred("change_scene_to_file", target)
	$TextureRect.visible = false
	$AnimationPlayer.play_backwards('dissolve')
