extends Container

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		size = Vector2($Options.size.x + 9, $Options.size.y + 16)
		fit_child_in_rect($Background, Rect2(Vector2(), size))
		position = -size/2

func set_some_setting():
	# Some setting changed, ask for children re-sort
	queue_sort()
