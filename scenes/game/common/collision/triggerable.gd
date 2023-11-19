class_name Triggerable
extends Area2D

@export var tag : String

func _ready():
	add_to_group("triggerable")

func trigger(tag_name: String):
	if tag.length() == 0 or not tag == tag_name:
		return
	_on_triggered()

func _on_triggered():
	print("Need implementation of _on_triggered() in file: %s" % name)

func _on_body_entered(body: Node):
	if body is Player:
		_player_entered(body as Player)
	else:
		_body_entered(body)
	pass

func _on_body_exited(body: Node):
	if body is Player:
		_player_exited(body as Player)
	else:
		_body_exited(body)
	pass

func _player_entered(_player: Player):
	pass

func _player_exited(_player: Player):
	pass

func _body_entered(_body: Node):
	pass

func _body_exited(_body: Node):
	pass
