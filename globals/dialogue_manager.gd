extends Node

const dialogue_scene := preload("res://scenes/ui/dialogue/dialogue.tscn")

var dialogue : Dialogue = null

func get_dialogue() -> Dialogue:
	# Returns the current active dialogue system
	return dialogue

func create_dialogue():
	# Creates a Dialogue instance at root/World/UI/Dialogue
	if not dialogue:
		dialogue = dialogue_scene.instantiate()
		get_tree().root.get_node("/root/Main/Game/UI").add_child(dialogue)
		return dialogue

func add_dialogue(id: String):
	# Loads dialogue to the active Dialogue.
	if dialogue:
		var game_text : Dictionary = GameText.get_text(id)
		dialogue.set_title(id)
		for txt in game_text.get("txt"):
			dialogue.add_content(txt)

func play_dialogue():
	# Activates and shows the current Dialogue.
	if dialogue:
		dialogue.advance_text()
		dialogue.visible = true

func end_dialogue():
	# Ends and frees the current Dialogue
	if dialogue:
		dialogue.end_playback()
