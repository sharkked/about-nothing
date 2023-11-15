class_name NPC
extends Actor

@onready var chatter := $Chatter

@export var text_id : String = ""
@export var watch_player : bool = true
@export var dialogue_radius : float = 128

var _dialogue_source : bool = false
var watch_object : PhysicsBody2D = null

func _ready():
	super._ready()

func ready():
	gravity = 100

func process(_delta):
	if is_on_floor():
		velocity.y = 0
		position.y = (position.y)
	
	if watch_object:
		var watch_dist = watch_object.global_position - global_position
		direction = Vector2.RIGHT * sign(watch_dist.x)
		if not text_id == "":
			chatter.visible = true
	else:
		chatter.visible = false
		if _dialogue_source:
			DialogueManager.end_dialogue()
	
	if _dialogue_source:
		chatter.visible = false
		if not DialogueManager.get_dialogue():
			_dialogue_source = false
	elif DialogueManager.get_dialogue():
		chatter.visible = false
		

func _input(_event):
	if Input.is_action_just_pressed("act"):
		if watch_object and GameText.get_text(text_id) and not DialogueManager.get_dialogue():
			print_debug("oooo")
			_dialogue_source = true
			DialogueManager.create_dialogue()
			DialogueManager.add_dialogue(text_id)
			DialogueManager.play_dialogue()

func _on_watch_area_body_entered(body):
	if watch_player:
		watch_object = body

func _on_watch_area_body_exited(body):
	if watch_object == body:
		watch_object = null
