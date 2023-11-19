class_name GameText

static func get_text(id):
	var text = {
		"test1" : {
			"txt" : [
				"{title fuckyou.mov}{voice 0}{sprite memo_neutral}guess we're back here again, huh?",
				"kinda annoying, but hey what're ya gonna do", 
				"although... things do seem a little [rainbow]nicer[/rainbow] this time",
				"hey, the void gets tiring after a while, ok?"
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
