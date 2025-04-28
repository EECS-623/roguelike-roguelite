class_name SpellCircle extends State

@onready var move : State = $"../Move"

@export var s_spell: PackedScene

var finished
var loki
var player


func enter() -> void:
	finished = false
	for i in range(6):
		var spell = s_spell.instantiate()
		spell.loki = loki
		spell.start_angle = (TAU / 6) * i
		spell.start_anim = i/6
		get_tree().current_scene.add_child(spell) # Replace with function body.
	
	await get_tree().create_timer(5).timeout
	finished = true


func state_process(delta : float) -> State:
	if finished:
		return move
	return null

		
func can_move_during():
	return true
