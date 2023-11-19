class_name NPC
extends Actor

@onready var chatter := $Chatter

@export var text_id := ""
@export var face_player := true

var is_talking := false
var in_target_area := false
var in_dialogue_area := false

var face_target : PhysicsBody2D = null

func _ready():
	super._ready()

func ready():
	gravity = 100

func process(_delta):
	if is_on_floor():
		velocity.y = 0
		position.y = (position.y)
	
	if face_target:
		var target_dist = face_target.global_position - global_position
		direction = Vector2.RIGHT * sign(target_dist.x)
	
	chatter.visible = has_dialogue() and in_dialogue_area and !is_talking

func has_dialogue():
	return GameText.get_text(text_id) != null

func _input(_event):
	if Input.is_action_just_pressed("act"):
		if in_dialogue_area and has_dialogue() and !DialogueManager.get_dialogue():
			is_talking = true
			DialogueManager.create_dialogue()
			DialogueManager.add_dialogue(text_id)
			DialogueManager.play_dialogue()
			
			var dialogue = DialogueManager.get_dialogue()
			if dialogue:
				dialogue.queue_empty.connect(_on_dialogue_end)

func _on_dialogue_end():
	is_talking = false

func _on_dialogue_area_entered(_player):
	in_dialogue_area = true

func _on_dialogue_area_exited(_player):
	in_dialogue_area = false
	if is_talking:
		DialogueManager.end_dialogue()
		is_talking = false

func _on_target_area_entered(player):
	if face_player:
		in_target_area = true
		face_target = player

func _on_target_area_exited(player):
	if face_target == player:
		in_target_area = false
		face_target = null
