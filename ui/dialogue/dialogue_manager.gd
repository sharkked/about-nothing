class_name DialogueManager

const dialogue_system := preload("res://ui/dialogue/dialogue_system.tscn")

static func get_dialogue() -> DialogueSystem:
	# Returns the current active dialogue system
	if Game.ui.has_node("Dialogue"):
		return Game.ui.get_node("Dialogue")
	return null

static func create_dialogue():
	# Creates a DialogueSystem instance at root/World/UI/Dialogue
	if not Game.ui.has_node("Dialogue"):
		Game.ui.add_child(dialogue_system.instantiate())
		
static func add_dialogue(id: String):
	# Loads dialogue to the active DialogueSystem.
	var ds := get_dialogue()
	if ds:
		var dialogue : Dictionary = GameText.get_text(id)
		ds.set_title(id)
		for i in dialogue.get("txt"):
			ds.add_content(i)

static func play_dialogue():
	# Activates and shows the current DialogueSystem.
	var ds := get_dialogue()
	if ds:
		ds.advance_text()
		ds.visible = true

static func end_dialogue():
	# Ends and frees the current DialogueSystem
	var ds := get_dialogue()
	if ds:
		ds.end_playback()
