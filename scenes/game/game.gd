extends Node

signal reload

@export var player_scene : PackedScene

const ROOM_PATH = "res://scenes/game/areas/rooms"
const SAVE_PATH = "user://saves"

var rooms := {}

@export var current_room : PackedScene
var player_spawn_name = "0"
var player_spawn : Marker2D

const QUIT_TIME : float = 1.0
var esc_hold = false
var quit_timer : float = 0

var root
var world
var ui

var room
var player

var debug_level = 0

var data = GameData.new()

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().set_auto_accept_quit(false)
	root = get_tree().root
	root.close_requested.connect(self._on_quit)
	reload.connect(self._on_reload)
	
	build_room_list()
	ui = $UI
	
	data_load()
	room_load_scene(current_room)

func _process(delta):
	if esc_hold:
		quit_timer += delta
	else:
		quit_timer = 0
	if quit_timer >= QUIT_TIME:
		_on_quit()
	
	$CanvasLayer/ExitLabel.modulate.a = quit_timer / QUIT_TIME

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			match event.keycode:
				KEY_R:
					reload.emit()
				KEY_T:
					data_save()
				KEY_ESCAPE:
					esc_hold = true
				KEY_BACKSPACE:
					if world:
						get_tree().paused = !get_tree().paused
				KEY_0:
					set_debug_level()
		elif not event.echo:
			match event.keycode:
				KEY_ESCAPE:
					esc_hold = false

## Room helpers
func build_room_list():
	var directory = DirAccess.open(ROOM_PATH)
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			var r = load(ROOM_PATH.path_join(filename))
			rooms[filename.substr(5).rstrip('.tscn')] = r
		filename = directory.get_next()

func room_get_scene(room_name: String) -> PackedScene:
	if rooms.has(room_name):
		return rooms[room_name]
	return null

func room_load_scene(room_scene: PackedScene):
	if has_node("Room"):
		if room.has_node("Player"):
			room.remove_child(player)
		remove_child(get_node("Room"))
		room.queue_free()
	
	current_room = room_scene
	room = room_scene.instantiate()
	add_child(room)
	
	player_spawn = room.get_node("Entrances/%s" % player_spawn_name)
	player_init(player_spawn.position)
	room.add_child(player)

func room_switch(room_name: String):
	var room_scene = room_get_scene(room_name)
	if room_scene:
		room_load_scene(room_scene)

## Player helpers
func player_init(position = Vector2.ZERO) -> Player:
	if !player:
		player = player_scene.instantiate()
	player.position = position
	return player

func player_destroy():
	if player:
		player.queue_free()
		player = null

## Save data handling

func data_save():
	var err
	
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		print("creating dir [%s]" % SAVE_PATH)
		err = DirAccess.make_dir_recursive_absolute(SAVE_PATH)
		if err:
			push_error("%d: could not create dir [%s]" % [err, SAVE_PATH])
			return
	
	# inventory
	var itemdata = {}
	for i in data.inventory.get_items():
		if not itemdata.has(i.item_reference.name):
			itemdata[i.item_reference.name] = 0
		itemdata[i.item_reference.name] += i.quantity
	
	var file = FileAccess.open(SAVE_PATH.path_join("1.dat"), FileAccess.WRITE)
	if FileAccess.get_open_error() != OK:
		push_error("%d: couldn't open file [%s]" % [FileAccess.get_open_error(), SAVE_PATH.path_join("1.dat")])
		return
	else:
		print("saving file [%s]" % SAVE_PATH.path_join("1.dat"))
	
	file.store_line(JSON.stringify(itemdata))
	file = null

func data_load():
	var file = FileAccess.open(SAVE_PATH.path_join("1.dat"), FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("%d: couldn't open file [%s]" % [FileAccess.get_open_error(), SAVE_PATH.path_join("1.dat")])
		return
	else:
		print("loading file [%s]" % SAVE_PATH.path_join("1.dat"))
	
	var json = JSON.new()
	var err = json.parse(file.get_line())
	
	if err:
		push_error("%d: couldn't read file contents" % err)
		return
	
	file = null
	
	var saved = json.get_data()
	data.inventory.set_items(Array())
	for i in saved:
		data.inventory.add_item(i, saved[i])

func set_debug_level():
	debug_level = (debug_level + 1) % 2
	match debug_level:
		0:
			get_tree().set_debug_collisions_hint(false) 
		1:
			get_tree().set_debug_collisions_hint(true) 

## Signal receivers
func _on_quit():
	get_tree().quit()

func _on_reload():
	if has_node("World/Room"):
		data_load()
		room_load_scene(current_room)
		CameraMan.camera_snap_focus()

