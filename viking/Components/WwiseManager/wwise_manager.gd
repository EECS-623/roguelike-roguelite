class_name WwiseManager extends Node2D

#@onready var ak = load("res://Wwise/resources/wwise_ids.gd")

#var music_dict := {
	#"MUSIC" = AK.EVENTS.MUSIC,
	 #"BOSS_DEATH"  = AK.EVENTS.BOSS_DEATH,
	 #"FIREBALL"  = AK.EVENTS.FIREBALL,
	 #"GAMESTART_MENU"  = AK.EVENTS.GAMESTART_MENU,
	 #"ITEM_ATTAIN"  = AK.EVENTS.ITEM_ATTAIN,
	 #"KEY_ATTAIN"  = AK.EVENTS.KEY_ATTAIN,
	 #"NEXT_DIALOUGE"  = AK.EVENTS.NEXT_DIALOUGE,
	 #"SPAWN"  = AK.EVENTS.SPAWN,
	 #"CHEST_OPEN"  = AK.EVENTS.CHEST_OPEN,
	 #"SNAKE_BITE"  = AK.EVENTS.SNAKE_BITE,
	 #"SNAKE_SPIT"  = AK.EVENTS.SNAKE_SPIT,
	 #"SWORD_ATTACK_PC"  = AK.EVENTS.SWORD_ATTACK_PC,
	 #"SWORD_SWING"  = AK.EVENTS.SWORD_SWING,
#}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#
#func get_ak_ant(path: String) -> int:
	#var parts = path.split(".")
	#
	#var result = ak
	#for part in parts:
		#if result.has(part):
			#result = result.get(part)
		#else:
			#push_error("Invalid AK constant path: %s" % path)
			#return -1
	#return result

#func play_wwise_event(event_name: String) -> void:
	#if music_dict.has(event_name):
		#var event_id = music_dict[event_name]
		#Wwise.post_event_id(event_id, self)
