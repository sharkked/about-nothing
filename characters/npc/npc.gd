class_name NPC
extends Character

@onready var chatter := $Chatter

@export var text_id : String = ""
@export var watch_player : bool = true
@export var watch_radius : float = 32
@export var dialogue_radius : float = 128

var player_dist : Vector2 = Vector2.UP * 100000000000

var _dialogue_source : bool = false

func _ready():
	super._ready()

func ready():
	gravity = 100

func process(_delta):
	if is_on_floor():
		velocity.y = 0
		position.y = (position.y)
	
	if Game.player:
		player_dist = Game.player.global_position - global_position
		if watch_player and abs(player_dist.length()) < watch_radius:
			direction = Vector2.RIGHT * sign(player_dist.x)
			if not text_id == "":
				chatter.visible = true
		else:
			chatter.visible = false
		
		if _dialogue_source and dialogue_radius < player_dist.length():
			DialogueManager.end_dialogue()
	else:
		chatter.visible = false
	
	if _dialogue_source:
		chatter.visible = false
		if not DialogueManager.get_dialogue():
			_dialogue_source = false
	elif DialogueManager.get_dialogue():
		chatter.visible = false
		

func _input(_event):
	if Input.is_action_just_pressed("act"):
		if player_dist.length() <= watch_radius and GameText.get_text(text_id) and not DialogueManager.get_dialogue():
			_dialogue_source = true
			DialogueManager.create_dialogue()
			DialogueManager.add_dialogue(text_id)
			DialogueManager.play_dialogue()
