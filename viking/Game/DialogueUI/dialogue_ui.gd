class_name DialogueUI extends CanvasLayer

@onready var background = $Background
@onready var speaker_name: RichTextLabel = $SpeakerName
@onready var dialogue_text: RichTextLabel = $DialogueText

var dialogue = []
var parsed_chars: Array = []
var current_line = 0
var current_text = ""
var char_index = 0
var typing_speed = 0.03
var typing_in_progress = false
var input_locked = false

var player_patron = {
	"thor" = false,
	"freya" = false,
	"tyr" = false
}

var player_god: bool = false

signal dialogue_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	var text_height = speaker_name.get_content_height()
	#speaker_name.position.y = (background.size.y - text_height) / 2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player_god:
		if Global.patron_god == 1:
			player_patron["thor"] = true
			player_god = true
		elif Global.patron_god == 2:
			player_patron["tyr"] = true
			player_god = true
		elif Global.patron_god == 3:
			player_patron["freya"] = true
			player_god = true

# takes lines of dialogue in, and parses based on conditions
func dialogue_begin(lines: Array) -> void:
	dialogue = []
	for line in lines:
		if line.has("condition"):
			var conditions = line["condition"]
			
			if typeof(conditions) == TYPE_STRING:
				if player_patron.get(conditions, false):
					dialogue.append(line)

			elif typeof(conditions) == TYPE_ARRAY:
				for condition in conditions:
					if player_patron.get(condition, false):
						dialogue.append(line)
						break 
		else:
			dialogue.append(line)

	current_line = 0
	visible = true
	show_line()
	$AnimationPlayer.play(speaker_name.text)


func show_line() -> void:
	var line = dialogue[current_line]
	speaker_name.text = line.name + ":"
	current_text = line.text
	dialogue_text.text = ""
	char_index = 0
	parsed_chars = parsed_bbcode(current_text)
	type_characters()
	
func type_characters() -> void:
	typing_in_progress = true
	while char_index < parsed_chars.size():
		dialogue_text.text += parsed_chars[char_index]
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout
		if not typing_in_progress:
			return
	
	typing_in_progress = false
	
func _unhandled_input(event: InputEvent) -> void:
	if input_locked:
		return 
		
	if event is InputEventMouseButton and visible:
		input_locked = true
		if typing_in_progress:
			
			typing_in_progress = false
			dialogue_text.text = current_text
		elif current_line + 1 < dialogue.size():
			
			current_line += 1
			show_line()
		else:
			dialogue_end()
		
		await get_tree().create_timer(0.15).timeout
		input_locked = false

func parsed_bbcode(bbcode_text: String) -> Array:
	var output: Array = []
	var tag_stack: Array = []
	var i = 0

	while i < bbcode_text.length():
		if bbcode_text[i] == "[":
			var end = bbcode_text.find("]", i)
			if end != -1:
				var tag = bbcode_text.substr(i, end - i + 1)
				if tag.begins_with("[/"):
					# Closing tag
					if tag_stack.size() > 0:
						tag_stack.pop_back()
				else:
					# Opening tag
					tag_stack.append(tag)
				output.append(tag)
				i = end + 1
				continue

		var prefix = ""
		for tag in tag_stack:
			prefix += tag

		var suffix = ""
		for j in range(tag_stack.size() - 1, -1, -1):
			var t = tag_stack[j]
			var tag_name = t.substr(1, t.find("=") - 1 if t.contains("=") else t.length() - 2)
			suffix += "[/" + tag_name + "]"
		output.append(prefix + bbcode_text[i] + suffix)
		i += 1

	return output


func load_dialogue(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	if data == null:
		push_error("Failed to parse data")
		return []
	return data

func dialogue_end() -> void:
	dialogue_finished.emit()
	visible = false
