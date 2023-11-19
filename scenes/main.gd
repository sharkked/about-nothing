extends Node

signal game_started

@export var game_scene : PackedScene
var game_world : Node2D

func _ready():
	SoundManager.play_bgm("dogvirus_chill")

func start_game():
	$TitleScreen.queue_free()
	
	game_world = game_scene.instantiate()
	add_child(game_world)
	
	emit_signal("game_started")

func _on_new_game():
	start_game()

func _on_load_game():
	start_game()

func _on_exit_game():
	get_tree().quit()
