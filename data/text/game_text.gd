class_name GameText

static func get_text(id):
	var text = {
		"test1" : {
			"txt" : [
				"{title fuckyou.mov}{voice 6}{sprite memo_neutral}whats up dickhead lolololololololololol",
				"check out motherfuckerr!!!", 
				"{voice sans}{sprite funny}[rainbow]ligma balls",
				"{voice 1}{sprite memo_neutral} pretty cool right haha"
			]
		},
		
		"virus1" : {
			"txt" : [
				"{title computervirus.bat}{sprite virus}{voice laurel}i got sucked out of [color=yellow]the plane[/color] and i opened the door and got sucked out of [color=yellow]the plane[/color]",
				"i opened the window and [color=yellow]the plane[/color] was moving and i got sucked out of [color=yellow]the plane[/color]"
			]
		}
	}
	if text.has(id):
		return text[id]
	else:
		return null
