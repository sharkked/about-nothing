extends Control

func load_options(options: Dictionary, callback: String):
	for op in options:
		var item
		match options[op]["type"]:
			"button":
				item = Button.new()
				item.text = options[op]["text"]
				item.align = HORIZONTAL_ALIGNMENT_LEFT
				item.connect("pressed", owner, callback, [item])
			"checkbox":
				item = CheckBox.new()
				item.text = options[op]["text"]
			"checkbutton":
				item.text = options[op]["text"]
				item = CheckButton.new()
			"progressbar":
				item = ProgressBar.new()
			_:
				item = Label.new()
				item.text = options[op]["text"]
		item.name = op
		if options[op].has("disabled") and options[op]["disabled"] == "true":
			item.disabled = true
		$Container/Options.add_child(item)
		if options[op].has("focus") and options[op]["focus"] == "true":
			item.grab_focus()
