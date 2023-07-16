extends Node

var focus_owner

var options = {
	"new_game": {
		"type": "button",
		"text": "New Game",
		"focus": "true"
	},
	
	"load_game": {
		"type": "button",
		"text": "Load Game",
		"disabled": "true",
	},
	
	"options": {
		"type": "button",
		"text": "Options",
		"submenu": {
			"video": {
				"type": "button",
				"text": "Load Game",
				"disabled": "true",
			},
			
			"sound": {
				"type": "button",
				"text": "Load Game",
				"disabled": "true",
			},
			
			"controls": {
				"type": "button",
				"text": "Load Game",
				"disabled": "true",
			},
			
			"return": {
				"type": "button",
				"text": "Load Game",
				"disabled": "true",
			},
		}
	},
	
	"exit": {
		"type": "button",
		"text": "Exit",
	},
}

@onready var new_game = $HBoxContainer/NewGame
@onready var load_game = $HBoxContainer/LoadGame
@onready var settings = $HBoxContainer/Settings
@onready var exit_game = $HBoxContainer/Exit

func _ready():
	$HBoxContainer/NewGame.grab_focus()
	focus_owner = new_game
	pass#menu.load_options(ops, "_on_wm_option_pressed")

func _input(_event):
	var new_focus = ""
	if Input.is_action_just_pressed("ui_down"):
		new_focus = focus_owner.focus_neighbor_bottom
	if Input.is_action_just_pressed("ui_up"):
		new_focus = focus_owner.focus_neighbor_top
	if Input.is_action_just_pressed("ui_left"):
		new_focus = focus_owner.focus_neighbor_left
	if Input.is_action_just_pressed("ui_right"):
		new_focus = focus_owner.focus_neighbor_right
	if focus_owner.has_node(new_focus):
		focus_owner = focus_owner.get_node(new_focus)
		focus_owner.grab_focus()

func _on_NewGame_pressed():
	Game.start()
	queue_free()

func _on_LoadGame_pressed():
	pass

func _on_Options_pressed():
	pass#$SettingsMenu.popup()

func _on_Exit_pressed():
	get_tree().quit()
