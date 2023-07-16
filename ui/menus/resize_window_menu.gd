extends Container

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		rect_size = Vector2($Options.rect_size.x + 9, $Options.rect_size.y + 16)
		fit_child_in_rect($Background, Rect2(Vector2(), rect_size))
		rect_position = -rect_size/2

func set_some_setting():
	# Some setting changed, ask for children re-sort
	queue_sort()
