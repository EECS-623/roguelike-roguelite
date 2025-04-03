class_name AggroRangeComponent extends Area2D

signal in_range(bool)
var in_aggro : bool
var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body is Player and body.is_in_group("player"):
		player = body
		in_aggro = true
		in_range.emit(true) 
	
func _on_body_exited(body: Node) -> void:
	if body is Player and body.is_in_group("player"):
		in_aggro = false
		in_range.emit(false) 
