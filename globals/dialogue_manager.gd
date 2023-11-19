extends Node

signal dialogue_started
signal dialogue_ended

const dialogue_scene := preload("res://scenes/ui/dialogue/dialogue.tscn")

var _dialogue : Dialogue = null

func get_dialogue() -> Dialogue:
	# Returns the current active _dialogue system
	return _dialogue

func create_dialogue():
	# Creates a Dialogue instance at root/World/UI/Dialogue
	if not _dialogue:
		_dialogue = dialogue_scene.instantiate()
		_dialogue.queue_empty.connect(end_dialogue)
		get_tree().root.get_node("/root/Main/Game/UI").add_child(_dialogue)
		return _dialogue

func add_dialogue(id: String):
	# Loads _dialogue to the active Dialogue.
	if _dialogue:
		var game_text : Dictionary = GameText.get_text(id)
		_dialogue.set_title(id)
		for txt in game_text.get("txt"):
			_dialogue.push_content(txt)

func is_playing():
	return _dialogue != null

func play_dialogue():
	# Activates and shows the current Dialogue.
	if _dialogue:
		_dialogue.advance_text()
		_dialogue.visible = true

func end_dialogue():
	# Ends and frees the current Dialogue
	if _dialogue:
		_dialogue.queue_free()
		_dialogue = null
