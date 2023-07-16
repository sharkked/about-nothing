extends Node

# don't forget to use stretch mode 'viewport' and aspect 'ignore'
@onready var viewport = get_viewport()

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F4:
			match DisplayServer.window_get_mode():
				DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN:
					DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
				DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
					DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)

func _ready():
	#DisplayServer.window_size = Vector2(960, 720) #Vector2(1600,900)#
	pass#get_tree().screen_resized.connect(self._screen_resized)

func _screen_resized():
	var window_size = DisplayServer.window_get_size() * 0.25

	# see how big the window is compared to the viewport size
	# floor it so we only get round numbers (0, 1, 2, 3 ...)
	var scale_x = floor(window_size.x / viewport.size.x)
	var scale_y = floor(window_size.y / viewport.size.y)

	# use the smaller scale with 1x minimum scale
	var scale = max(1, min(scale_x, scale_y))

	# find the coordinate we will use to center the viewport inside the window
	var diff = window_size - (viewport.size * scale)
	var diffhalf = (diff * 0.5).floor()

	# attach the viewport to the rect we calculated
	viewport.set_attach_to_screen_rect(Rect2(diffhalf, viewport.size * scale))
