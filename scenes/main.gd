extends Node

signal game_start

@export var game_scene : PackedScene
var game_world : Node2D

func start_game():
	print_debug("haiii")
	emit_signal("game_start")
	$TitleScreen.queue_free()
	game_world = game_scene.instantiate()
	add_child(game_world)

func _on_new_game():
	start_game()

func _on_load_game():
	start_game()

func _on_exit_game():
	get_tree().quit()
